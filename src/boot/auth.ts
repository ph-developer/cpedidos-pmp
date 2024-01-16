import { boot } from 'quasar/wrappers';
import { getAuth } from 'firebase/auth';

export default boot(async () => {
  const auth = getAuth();

  await new Promise((resolve) => {
    auth.onAuthStateChanged(resolve);
  });
});
