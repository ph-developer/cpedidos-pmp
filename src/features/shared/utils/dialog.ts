import { useQuasar } from 'quasar';

export const useDialog = () => {
  const $q = useQuasar();

  const confirm = (title: string, message: string, onOk: () => void) => {
    $q.dialog({
      title,
      message,
      ok: {
        outlined: true,
        label: 'Sim',
      },
      cancel: {
        outlined: true,
        label: 'Cancelar',
      },
    })
      .onOk(onOk);
  };

  return {
    confirm,
  };
};
