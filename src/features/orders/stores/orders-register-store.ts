import { defineStore } from 'pinia';
import { ref } from 'vue';
import { Order } from 'src/features/orders/types/order';
import { OrderQuery } from 'src/features/orders/types/order-query';
import { debounce1 } from 'src/features/shared/utils/debounce';
import { Failure, UnknownError } from 'src/features/shared/errors/failures';
import { OrderNotFound } from 'src/features/orders/errors/order-failures';
import { useOrderRepository } from 'src/features/orders/repositories/order-repository';

export const useOrdersRegisterStore = defineStore(
  'ordersRegister',
  () => {
    // Inject

    const orderRepository = useOrderRepository();

    // State

    const isSearching = ref(false);
    const isLoading = ref(false);
    const isLoaded = ref(false);
    const loadedOrder = ref<Order | null>(null);
    const currentQuery = ref<OrderQuery | null>(null);

    const success = ref<'SAVE' | 'DELETE' | null>(null);
    const failure = ref<Failure | null>(null);

    // Actions

    const clearSearch = async () => {
      isLoading.value = true;
      loadedOrder.value = null;
      currentQuery.value = null;
      isLoaded.value = false;
      failure.value = null;
      isLoading.value = false;
    };

    const internalSearchOrder = async (query: OrderQuery) => {
      if (query.number !== '') {
        try {
          const order = await orderRepository.getOrderByTypeAndNumber(query.type, query.number);

          if (query.number !== currentQuery.value?.number) return;
          if (query.type !== currentQuery.value?.type) return;

          loadedOrder.value = order;
          isLoaded.value = true;
        } catch (e) {
          if (query.number !== currentQuery.value?.number) return;
          if (query.type !== currentQuery.value?.type) return;

          loadedOrder.value = null;

          if (e instanceof OrderNotFound) {
            isLoaded.value = true;
          } else if (e instanceof Failure) {
            isLoaded.value = false;
            failure.value = e;
          } else {
            isLoaded.value = false;
            failure.value = new UnknownError();
          }
        }
      }
      isSearching.value = false;
    };

    const debouncedInternalSearchOrder = debounce1(internalSearchOrder, 500);

    const searchOrder = async (query: OrderQuery) => {
      isSearching.value = true;
      loadedOrder.value = null;
      isLoaded.value = false;
      failure.value = null;
      currentQuery.value = query;
      await debouncedInternalSearchOrder(query);
    };

    const saveOrder = async (order: Order) => {
      isLoading.value = true;
      success.value = null;
      failure.value = null;

      try {
        loadedOrder.value = await orderRepository.saveOrder(order);
        isLoaded.value = true;
        success.value = 'SAVE';
      } catch (e) {
        if (e instanceof Failure) {
          failure.value = e;
        } else {
          failure.value = new UnknownError();
        }
      }

      isLoading.value = false;
    };

    const deleteOrder = async (order: Order) => {
      isLoading.value = true;
      success.value = null;
      failure.value = null;

      try {
        await orderRepository.deleteOrder(order);
        loadedOrder.value = null;
        success.value = 'DELETE';
      } catch (e) {
        if (e instanceof Failure) {
          failure.value = e;
        } else {
          failure.value = new UnknownError();
        }
      }

      isLoading.value = false;
    };

    // Return

    return {
      isSearching,
      isLoading,
      isLoaded,
      loadedOrder,
      currentQuery,
      success,
      failure,
      clearSearch,
      searchOrder,
      saveOrder,
      deleteOrder,
    };
  },
);
