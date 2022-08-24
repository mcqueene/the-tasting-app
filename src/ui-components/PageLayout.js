import Typography from "@mui/material/Typography";
import NavBar from "./NavBar";

export const PageLayout = (props) => {
    return (
        <>
            <NavBar environment={props.environment} />
            <Paper >
                <Box>
                    <Box sx={{ mx: 'auto', width: 'auto', textAlign: 'center', }}>
                        <Typography align="center" variant="h5">The Tasting App</Typography>
                    </Box>
                    <br />
                    <br />
                    {props.children}
                </Box>
            </Paper>
        </>
    );
};