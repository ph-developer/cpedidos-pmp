import { defineStore } from 'pinia';
import { useOrderRepository } from 'src/features/orders/repositories/order-repository';
import { ref } from 'vue';
import { Order } from 'src/features/orders/types/order';
import { Failure, UnknownError } from 'src/features/shared/errors/failures';
import { OrdersSearchQuery } from 'src/features/orders/types/orders-search-query';
import { OrdersSearchType } from 'src/features/orders/types/orders-search-type';

export const useOrdersSearchStore = defineStore(
  'ordersSearch',
  () => {
    // Inject

    const orderRepository = useOrderRepository();

    // State

    const isLoading = ref(false);
    const isLoaded = ref(false);
    const loadedOrders = ref<Order[]>([]);

    const failure = ref<Failure | null>(null);

    // Actions

    const clearSearch = async () => {
      isLoading.value = true;
      isLoaded.value = false;
      loadedOrders.value = [];
      failure.value = null;
      isLoading.value = false;
    };

    const searchOrders = async (query: OrdersSearchQuery) => {
      isLoading.value = true;
      isLoaded.value = false;
      loadedOrders.value = [];
      failure.value = null;

      let searchOrdersFn: ((query: string) => Promise<Order[]>) | null = null;

      if (query.type === OrdersSearchType.SEND_DATE) {
        searchOrdersFn = orderRepository.getAllOrdersBySendDate;
      } else if (query.type === OrdersSearchType.ARRIVAL_DATE) {
        searchOrdersFn = orderRepository.getAllOrdersByArrivalDate;
      }

      if (searchOrdersFn !== null) {
        try {
          loadedOrders.value = await searchOrdersFn(query.value);
          isLoaded.value = true;
        } catch (e) {
          if (e instanceof Failure) {
            failure.value = e;
          } else {
            failure.value = new UnknownError();
          }
        }
      }

      isLoading.value = false;
    };

    // Return

    return {
      isLoading,
      isLoaded,
      loadedOrders,
      failure,
      clearSearch,
      searchOrders,
    };
  },
);
