import { useQuasar } from 'quasar';

export const useNotify = () => {
  const $q = useQuasar();

  const error = (message: string) => {
    $q.notify({
      message,
      type: 'negative',
    });
  };

  const success = (message: string) => {
    $q.notify({
      message,
      type: 'positive',
    });
  };

  return {
    error,
    success,
  };
};
