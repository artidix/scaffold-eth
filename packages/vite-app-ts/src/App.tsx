import '~~/styles/tailwind.css';
import '~~/styles/globals.css';

import { EthComponentsSettingsContext, IEthComponentsSettings } from 'eth-components/models';
import { EthersAppContext } from 'eth-hooks/context';
import { lazier } from 'eth-hooks/helpers';
import React, { FC, ReactNode, Suspense } from 'react';
import { ThemeSwitcherProvider } from 'react-css-theme-switcher';
import { QueryClient, QueryClientProvider } from 'react-query';

import { ErrorBoundary, ErrorFallback } from '~common/components';

const BLOCKNATIVE_DAPPID = import.meta.env.VITE_KEY_BLOCKNATIVE_DAPPID;
const savedTheme = window.localStorage.getItem('theme') ?? 'light';
const themes = {
  dark: './ant-dark-theme.css',
  light: './ant-light-theme.css',
};

const ethComponentsSettings: IEthComponentsSettings = {
  apiKeys: {
    BlocknativeDappId: BLOCKNATIVE_DAPPID,
  },
};

const queryClient = new QueryClient();

const MainPage = lazier(() => import('./pages/MainPage'), 'MainPage');

const ProviderWrapper: FC<{ children?: ReactNode }> = (props) => {
  return (
    <EthComponentsSettingsContext.Provider value={ethComponentsSettings}>
      <EthersAppContext disableDefaultQueryClientRoot={true}>
        <ErrorBoundary FallbackComponent={ErrorFallback}>
          <ThemeSwitcherProvider themeMap={themes} defaultTheme={savedTheme ?? 'light'}>
            <ErrorBoundary FallbackComponent={ErrorFallback}>{props.children}</ErrorBoundary>
          </ThemeSwitcherProvider>
        </ErrorBoundary>
      </EthersAppContext>
    </EthComponentsSettingsContext.Provider>
  );
};

const App: FC = () => {
  console.log('loading app...');
  return (
    <ErrorBoundary FallbackComponent={ErrorFallback}>
      <QueryClientProvider client={queryClient}>
        <ProviderWrapper>
          <Suspense fallback={<div />}>
            <MainPage></MainPage>
          </Suspense>
        </ProviderWrapper>
      </QueryClientProvider>
    </ErrorBoundary>
  );
};

export default App;
