import axios from 'axios';
export async function getJsonFile(theUrl) {
    //console.log('calling axios get to url', theUrl)
    try {
      await axios({
        url: theUrl,
        method: 'GET',
        //responseType: 'text/xml', // important
      }).then((response) => {
        //console.log('axios response', response)
        return response;
      });
    }
    catch(err) {
        console.log('axios error', err)
        this.props.showError('ERROR', JSON.stringify(err));
        return false;
    }
  }
export async function sendGetRequest(theUrl) {
    try {
        //console.log(theUrl)
        const resp = await axios.get(theUrl);
        //console.log(resp.data);
        return resp.data;
    } catch (err) {
        // Handle Error Here
        console.error(err);
    }
};
