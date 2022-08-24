import './App.css';
import React from 'react';
import { PageLayout } from "./ui-components/PageLayout";
import  MasterList from "./pages/MasterList";

// npm run deploy
//import inputMasterFile from './data/btg_master_list_20211003.json'
//import inputMasterFile from 'https://github.com/mcqueene/the-tasting-app/blob/e4dd46ce51731314a8ec3c0d2d7a3f1db4e48704/btg_master_list_20211003.json'
//import inputMasterFile from 'https://raw.githubusercontent.com/mcqueene/the-tasting-app/master/btg_master_list_20211003.json'

const App2 = (props) => {
    return (
        <PageLayout>
            <Pages  />
        </PageLayout>
    );
}

function Pages({ pca, props }) {
    return (
        <Routes>
            <Route path="/stylelist" element={<StyleList  />} />
            <Route path="/tgmissinglist" element={<TgMissingList  />} />
            <Route path="/" element={<MasterList />} />
        </Routes>
    )
}

export default App2;
