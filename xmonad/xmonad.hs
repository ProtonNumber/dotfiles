import XMonad

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.InsertPosition

import XMonad.Util.EZConfig
import XMonad.Util.Loggers
import XMonad.Util.Ungrab
import XMonad.Util.SpawnOnce

import XMonad.Layout.Magnifier
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Spacing

import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8

import System.Taffybar.Support.PagerHints (pagerHints)

main :: IO ()
main = do
	xmonad $ ewmh $ docks $ pagerHints $ myConfig

myConfig = def
	{ modMask = mod4Mask
	, layoutHook = spacingWithEdge 5 $ myLayout
	, manageHook = insertPosition End Newer
	, startupHook = startup
	, terminal = "alacritty"			-- I dunno what emulator it uses by default, but I hate it
	, workspaces = myWorkspaces
	, borderWidth = 0
	}
	`additionalKeysP`
	[ ("M-S-s", unGrab *> spawn "scrot -s -e 'xclip -selection clipboard -t image/png -i $f && rm $f'")		-- Take a screenshot of an area
	, ("M-C-s", unGrab *> spawn "scrot -e 'xclip -selection clipboard -t image/png -i $f && rm $f'")
	, ("M-w", kill)							-- Close windows
	, ("M-r", spawn ".config/rofi/launchers/ribbon/launcher.sh")	-- Run launcher
	, ("M-p", spawn ".config/rofi/powermenu/powermenu.sh")		-- Run power menu
	]

startup = do
	spawnOnce "taffybar"
	spawnOnce "picom -cC --corner-radius 10"

myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

myLayout = avoidStruts ( tiled ||| Mirror tiled ||| Full )
	where
		tiled = Tall nmaster delta ratio
		nmaster = 1
		ratio = 2/3
		delta = 3/100
