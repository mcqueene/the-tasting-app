import * as React from 'react';
import AppBar from "@mui/material/AppBar";
import Toolbar from "@mui/material/Toolbar";
import Link from "@mui/material/Link";
import Chip from "@mui/material/Chip";
import Typography from "@mui/material/Typography";
import useStyles from "../styles/useStyles";
import { Link as RouterLink } from "react-router-dom";
import MenuIcon from '@mui/icons-material/Menu';
import {Menu, MenuItem, IconButton} from '@mui/material';
const NavBar = (props) => {
    const classes = useStyles();
    const isAdmin = true;    
    const [anchorEl, setAnchorEl] = React.useState(null);
    const [anchorMain, setAnchorMain] = React.useState(null);
    const handleMenu = (event) => {
        setAnchorEl(event.currentTarget);
    };
    const handleClose = () => {
        setAnchorEl(null);
    };
    const handleMenuMain = (event) => {
        setAnchorMain(event.currentTarget);
    };
    const handleCloseMain = () => {
        setAnchorMain(null);
    };
        return (
        <div className={classes.root}>
            <AppBar position="static">
                <Toolbar>
                <IconButton
                        size="large"
                        edge="start"
                        color="inherit"
                        aria-label="menu"
                        aria-controls="menu-appbar-main"
                        onClick={handleMenuMain}
                        sx={{ mr: 2 }}>
                        <MenuIcon />
                    </IconButton>
                    <Menu
                        id="menu-appbar-main"
                        anchorEl={anchorMain}
                        anchorOrigin={{
                            vertical: 'top',
                            horizontal: 'right',
                        }}
                        keepMounted
                        transformOrigin={{
                            vertical: 'top',
                            horizontal: 'right',
                        }}
                        open={Boolean(anchorMain)}
                        onClose={handleCloseMain}
                        >
                        <MenuItem component={RouterLink} to="/">Find Past Beers</MenuItem>
                        <MenuItem component={RouterLink} to="/tgmissinglist">Thirsty Growler Missing List</MenuItem>
                        <MenuItem component={RouterLink} to="/stylelist">Style List</MenuItem>
                    </Menu>                    
                    <Typography className={classes.title}>
                        <Link component={RouterLink} to="/" color="inherit" variant="h6">The Tasting App</Link>
                    </Typography>
                    <Chip size='small' label={props.environment} color='warning' variant={'filled'}/>
                </Toolbar>
            </AppBar>
        </div>
    );
};

export default NavBar;