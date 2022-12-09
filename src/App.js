import './App.css';
import React, { useRef } from 'react';
// npm run deploy
//import inputMasterFile from './data/btg_master_list_20211003.json'
//import inputMasterFile from 'https://github.com/mcqueene/the-tasting-app/blob/e4dd46ce51731314a8ec3c0d2d7a3f1db4e48704/btg_master_list_20211003.json'
//import inputMasterFile from 'https://raw.githubusercontent.com/mcqueene/the-tasting-app/master/btg_master_list_20211003.json'
import { DataGrid, GridToolbarExport, GridToolbarContainer } from '@mui/x-data-grid';
import { TextField, Box, Typography, Paper } from '@mui/material';
import { sendGetRequest } from './FileService';
import Button from '@mui/material/Button';
import Stack from '@mui/material/Stack';
//import { makeStyles } from '@mui/styles';

const App = (props) => {

  //const url = 'https://raw.githubusercontent.com/mcqueene/the-tasting-app/master/btg_master_list_20211003.json'
  //let fileArray = []
  //const fileArray = getMasterFile()
  //fileArray = sendGetRequest(url);
  //console.log(fileArray)
  const [pageSize, setpageSize] = React.useState(20);
  const [inputMasterFile, setinputMasterFile] = React.useState([])
  const [inputMasterListArray, setinputMasterListArray] = React.useState([]);
  const [beerNameFilterValue, setbeerNameFilterValue] = React.useState('');
  const [brewerFilterValue, setbrewerFilterValue] = React.useState('');
  const [stateCountryFilterValue, setstateCountryFilterValue] = React.useState('');
  const [updatedOn, setupdatedOn] = React.useState('');
  const [totalCount, settotalCount] = React.useState(0);
  const [inputFocus, setinputFocus] = React.useState('');
  const refBeerName = useRef(null);
  const refBrewer = useRef(null);
  const refStateCountry = useRef(null);
 
  //used to track when the user object if finally loaded
  React.useEffect(() => {
    loadMasterList()
  }, [])

  React.useEffect(() => {
    const applyFilters = (beerName, brewerName, stateCountry) => {
      let newArray = [];
      if (beerName.length !== 0) {
        newArray = inputMasterFile.filter((obj) => obj.Beer.toUpperCase().includes(beerName.toUpperCase()));
        if (brewerName.length !== 0) {
          newArray = newArray.filter((obj) => obj.Brewer.toUpperCase().includes(brewerName.toUpperCase()));
        }
        if (stateCountry.length !== 0) {
          newArray = newArray.filter((obj) => obj.StateCountry.toUpperCase().includes(stateCountry.toUpperCase()));
        }
      }
      else {
        if (brewerName.length !== 0) {
          newArray = inputMasterFile.filter((obj) => obj.Brewer.toUpperCase().includes(brewerName.toUpperCase()));
          if (stateCountry.length !== 0) {
            newArray = newArray.filter((obj) => obj.StateCountry.toUpperCase().includes(stateCountry.toUpperCase()));
          }
        }
        else {
          if (stateCountry.length !== 0) {
            newArray = inputMasterFile.filter((obj) => obj.StateCountry.toUpperCase().includes(stateCountry.toUpperCase()));
          }
        }
      }
      setinputMasterListArray(newArray);
    }
    //run filter
    applyFilters(beerNameFilterValue, brewerFilterValue, stateCountryFilterValue)
  }, [beerNameFilterValue, brewerFilterValue, stateCountryFilterValue, inputMasterFile])


  const onPageSizeChangeEvent = (e) => {
    setpageSize(e);
  }

  const loadMasterList = async () => {
    //const url = 'https://github.com/mcqueene/the-tasting-app/blob/e4dd46ce51731314a8ec3c0d2d7a3f1db4e48704/btg_master_list_20211003.json'
    const url = 'https://raw.githubusercontent.com/mcqueene/the-tasting-app/master/btg_master_list.json'
    //mrm for some reason the file is from the src direction and not the data sub directory
    // i don't know why
    const changeFile = await sendGetRequest(url)
    console.log('file loaded from github with row count = ', changeFile.length)
    settotalCount(changeFile.length)
    const firstobj = changeFile[0]
    setupdatedOn(firstobj.DateTasted)
    console.log('last taste date', firstobj)

    const sortedArray = [...changeFile].sort((a, b) => a.Beer > b.Beer ? 1 : -1);

    setinputMasterFile(sortedArray)
  }

  const onBeerNameFilterChange = (event) => {
    const newValue = event.target.value;
    setbeerNameFilterValue(newValue);
    setinputFocus('beername');
  };
  const onBrewerFilterChange = (event) => {
    const newValue = event.target.value;
    setbrewerFilterValue(newValue);
    setinputFocus('brewer');
  };
  const onStateCountryFilterChange = (event) => {
    const newValue = event.target.value;
    setstateCountryFilterValue(newValue);
    setinputFocus('statecountry');
  };

  const onClearFilterClick = () => {
    setbeerNameFilterValue(''); 
    setbrewerFilterValue(''); 
    setstateCountryFilterValue('');
    if(inputFocus === 'beername') {
      refBeerName.current.focus();
    }
    if(inputFocus === 'brewer') {
      refBrewer.current.focus();
    }
    if(inputFocus === 'statecountry') {
      refStateCountry.current.focus();
    }

  }
  //https://stackoverflow.com/questions/72240266/how-to-export-all-the-pages-to-csv-in-mui-datagrid
  //https://mui.com/x/react-data-grid/export/#exported-rows
  const MyExportButton = () => {
    return (
      <GridToolbarContainer>
        <GridToolbarExport />
      </GridToolbarContainer>
    );
  }
  const columns = [
    {
      field: "Beer",
      headerName: "Beer Name",
      sortable: true,
      width: 290,
    },
    {
      field: 'Brewer',
      headerName: 'Brewer',
      width: 180,
      editable: false,
    },
    {
      field: 'DateTasted',
      headerName: 'Date',
      width: 115,
      editable: false,
    },
    {
      field: 'StatedStyle',
      headerName: 'Style',
      width: 150,
      editable: false,
    },
    {
      field: 'ABV',
      headerName: 'ABV',
      width: 120,
      editable: false,
    },
    {
      field: 'Taste',
      headerName: 'Taste',
      width: 100,
      editable: false,
      sortable: false,
    },
    {
      field: 'Style',
      headerName: 'Style',
      width: 100,
      editable: false,
      sortable: false,
    },
    {
      field: 'OverallScore',
      headerName: 'Overall',
      width: 100,
      editable: false,
      sortable: false,
    },
    {
      field: 'Container',
      headerName: 'Container',
      width: 150,
      editable: false,
    },
    {
      field: 'City',
      headerName: 'City',
      width: 150,
      editable: false,
    },
    {
      field: 'StateCountry',
      headerName: 'StateCountry',
      width: 150,
      editable: false,
    },
    {
      field: 'Vintage',
      headerName: 'Vintage',
      width: 150,
      editable: false,
    },
    {
      field: 'Comments',
      headerName: 'Comments',
      width: 250,
      editable: false,
    },
  ];

  return (

    <Paper >
      <Box>
        <Box sx={{ mx: 'auto', width: 'auto', textAlign: 'center', }}>
          <Typography align="center" variant="h5">The Tasting App</Typography>
          <Typography align="center" variant="subtitle1">Updated on: {updatedOn} Filtered Count: {inputMasterListArray.length} Total Count: {totalCount}</Typography>
        </Box>
        <Box >
          <Box sx={{ mx: 'auto', flexGrow: 1, textAlign: 'center', m: 1, p: 1 }}>
            <Typography align="center" variant="subtitle1">Start typing in box below to begin filtering</Typography>
            <Stack direction="row" spacing={2} alignItems="center" justifyContent="center">
              <TextField
                required
                id="inBeerName"
                inputRef={refBeerName}
                label="Beer Name Filter"
                variant="outlined"
                onChange={onBeerNameFilterChange}
                value={beerNameFilterValue}
              />
              <TextField
                required
                id="inBrewer"
                inputRef={refBrewer}
                label="Brewer Filter"
                variant="outlined"
                onChange={onBrewerFilterChange}
                value={brewerFilterValue}
              />
              <TextField
                required
                id="inStateCountry"
                inputRef={refStateCountry}
                label="State/Country"
                variant="outlined"
                onChange={onStateCountryFilterChange}
                value={stateCountryFilterValue}
              />
            </Stack>
            <Stack direction="row" sx={{p: 1}} spacing={2} alignItems="center" justifyContent="center">
              <Button
                onClick={onClearFilterClick}
                variant="contained">Clear Filters
              </Button>
            </Stack>
          </Box>
        </Box>
        <div style={{ height: 600, width: '98%' }}>
          <DataGrid
            rows={inputMasterListArray}
            columns={columns}
            rowsPerPageOptions={[5, 10, 20, 30, 50, 100]}
            pageSize={pageSize}
            onPageSizeChange={onPageSizeChangeEvent}
            pagination
            autoPageSize
            autoHeight={true}
            disableSelectionOnClick
            components={{
              Toolbar: MyExportButton,
            }}
            initialState={{
              sorting: {
                sortModel: [
                  {
                    field: 'Beer',
                    sort: 'asc',
                  }
                ],
              },
            }}
          />
        </div>

      </Box>
      <Typography align="center" variant="subtitle2">Last updated 10/23/2022</Typography>
    </Paper>

  );
}

export default App;
