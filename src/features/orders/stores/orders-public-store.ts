import { defineStore } from 'pinia';
import { ref } from 'vue';
import { Order } from 'src/features/orders/types/order';
import { OrderQuery } from 'src/features/orders/types/order-query';
import { Failure, UnknownError } from 'src/features/shared/errors/failures';
import { OrderNotFound } from 'src/features/orders/errors/order-failures';
import { useOrderRepository } from 'src/features/orders/repositories/order-repository';

export const useOrdersPublicStore = defineStore(
  'ordersPublic',
  () => {
    // Inject

    const orderRepository = useOrderRepository();

    // State

    const isLoading = ref(false);
    const isLoaded = ref(false);
    const loadedOrder = ref<Order | null>(null);
    const failure = ref<Failure | null>(null);

    // Actions

    const clearSearch = async () => {
      isLoading.value = true;
      loadedOrder.value = null;
      isLoaded.value = false;
      failure.value = null;
      isLoading.value = false;
    };

    const searchOrder = async (query: OrderQuery) => {
      isLoading.value = true;
      loadedOrder.value = null;
      isLoaded.value = false;
      failure.value = null;

      if (query.number === '') return;
      try {
        loadedOrder.value = await orderRepository.getOrderByTypeAndNumber(query.type, query.number);
        isLoaded.value = true;
      } catch (e) {
        if (e instanceof OrderNotFound) {
          isLoaded.value = true;
        } else if (e instanceof Failure) {
          isLoaded.value = false;
          failure.value = e;
        } else {
          isLoaded.value = false;
          failure.value = new UnknownError();
        }
        loadedOrder.value = null;
      }

      isLoading.value = false;
    };

    // Return

    return {
      isLoading,
      isLoaded,
      loadedOrder,
      failure,
      clearSearch,
      searchOrder,
    };
  },
);
