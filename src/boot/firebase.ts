import { boot } from 'quasar/wrappers';
import { FirebaseOptions, initializeApp } from 'firebase/app';

export default boot(() => {
  const firebaseConfig: FirebaseOptions = {
    apiKey: 'AIzaSyDbQwbuBUjeihngpS2NRDXOkTecpXY4eCs',
    authDomain: 'dev-cpedidos-pmp.firebaseapp.com',
    projectId: 'dev-cpedidos-pmp',
    storageBucket: 'dev-cpedidos-pmp.appspot.com',
    messagingSenderId: '152210893751',
    appId: '1:152210893751:web:32d7c4bb73d50900079632',
  };

  initializeApp(firebaseConfig);
});
