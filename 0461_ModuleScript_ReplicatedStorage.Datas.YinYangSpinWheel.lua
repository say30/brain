--[[
  Extracted from: ReplicatedStorage.Datas.YinYangSpinWheel
  Class: ModuleScript
  Source file: rickdev.rbxlx
]]

-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- BgMZBFR5cGUHRGlzcGxheQRJY29uBUluZGV4CE11dGF0aW9uBldlaWdodAZBbmltYWy/ATxzdHJva2UgY29sb3I9JyNmZmYnIHRoaWNrbmVzcz0nMic+PGZvbnQgY29sb3I9JyMwMDAnPllpbjwvZm9udD48L3N0cm9rZT4gPHN0cm9rZSB0aGlja25lc3M9JzInPjxmb250IGNvbG9yPScjZmZmJz5ZYW5nPC9mb250PgpCaXNvbnRlIEdpdXBwaXRlcmUKPGZvbnQgY29sb3I9JyMyYmZmNWMnPiQyLjRNL3M8L2ZvbnQ+PC9zdHJva2U+G3JieGFzc2V0aWQ6Ly83ODg3NzA1NzI3MDU4NRJCaXNvbnRlIEdpdXBwaXRlcmUHWWluWWFuZwlDYXNoLVBhY2sMQ2FzaCBQYWNrICMyDENhc2ggUGFjayAjMwRJdGVtDVlpbiBZYW5nIFNsYXAbcmJ4YXNzZXRpZDovLzcyNTIzNTE4Mzk0OTQyDENhc2ggUGFjayAjNQtTZXJ2ZXItTHVjaxtyYnhhc3NldGlkOi8vOTg5MDMxNDMzMzUwOTcSMnggU2VydmVyIEx1Y2sKMTVtB1Jld2FyZHMNWWluIFlhbmcgTGFtcBxyYnhhc3NldGlkOi8vMTA2Mzk4NTg1MzA3Mjc5CkFsdFJld2FyZHMAAQkAAAECAHmjAAAA/wACAAAAAAD/AQAABgAAAOICBgBvAwcAMAMCEQAAAABvAwgAMAMCPAEAAABvAwkAMAMCrgIAAABvAwoAMAMC4gMAAABvAwsAMAMCTQQAAACMAwEAMAMCqwUAAADiAwwAbwQNADAEAxEAAAAAbwQOADAEAzwBAAAAbwQPADAEA+IDAAAAjAQ3ADAEA6sFAAAA4gQMAG8FDQAwBQQRAAAAAG8FEAAwBQQ8AQAAAG8FEQAwBQTiAwAAAIwFIgAwBQSrBQAAAOIFEgBvBhMAMAYFEQAAAABvBhQAMAYFPAEAAABvBhUAMAYFrgIAAABvBhQAMAYF4gMAAABvBhYAMAYFqwUAAADiBgwAbwcNADAHBhEAAAAAbwcXADAHBjwBAAAAbwcYADAHBuIDAAAAbwcZADAHBqsFAAAA4gcaAG8IGwAwCAcRAAAAAG8IHAAwCAeuAgAAAG8IHQAwCAc8AQAAAIwIAQAwCAfiAwAAAIwIAgAwCAerBQAAAMUBAgcBAAAAMAEAFR4AAAD/AQEAAAAAAOICEgBvAxMAMAMCEQAAAABvAx8AMAMCPAEAAABvAyAAMAMCrgIAAABvAx8AMAMC4gMAAABvAyEAMAMCqwUAAAD2AgEDMAEAaSIAAACCAAIAIwMBAwIDAwMEAwUDBgUGAAECAwQFAwcDCAMJAwoDCwUEAAEDBQMMAw0CAADg0XuD6EEDDgIAACDbe4PoQQUFAAECAwUDDwMQAxECAAAAAAAA4D8DEgIAAMDwe4PoQQIAAAAAAAAeQAUFAAIBAwUDEwMUAxUDFgMXAxgCmpmZmZmZuT8DGQABAAEYAA8AAgABAQAAAQAAAQAAAQAAAQAAAQAAAwEAAAEAAAEAAAEAAAIBAAABAAABAAABAAADAQAAAQAAAQAAAQAAAQAAAwEAAAEAAAEAAAEAAAMBAAABAAABAAABAAABAAAAANUALwABAQAAAQAAAQAAAQAAAQAA+/8ACgEAAAAAAIdOaMAtj+AatYoCVDijmRLa/QwlU1Gwj/+zLFbb/Vv4hm6bXTYcljI=

-- Decompiler will be improved VERY SOON!
-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2025-09-27 10:50:13
-- Luau version 6, Types version 3
-- Time taken: 0.000714 seconds

return {
	Rewards = {{
		Type = "Animal";
		Display = "<stroke color='#fff' thickness='2'><font color='#000'>Yin</font></stroke> <stroke thickness='2'><font color='#fff'>Yang</font>\nBisonte Giuppitere\n<font color='#2bff5c'>$2.4M/s</font></stroke>";
		Icon = "rbxassetid://78877057270585";
		Index = "Bisonte Giuppitere";
		Mutation = "YinYang";
		Weight = 1;
	}, {
		Type = "Cash-Pack";
		Display = "Cash Pack #2";
		Index = 3290160783;
		Weight = 55;
	}, {
		Type = "Cash-Pack";
		Display = "Cash Pack #3";
		Index = 3290160857;
		Weight = 34;
	}, {
		Type = "Item";
		Display = "Yin Yang Slap";
		Icon = "rbxassetid://72523518394942";
		Index = "Yin Yang Slap";
		Weight = 0.5;
	}, {
		Type = "Cash-Pack";
		Display = "Cash Pack #5";
		Index = 3290161030;
		Weight = 7.5;
	}, {
		Type = "Server-Luck";
		Icon = "rbxassetid://98903143335097";
		Display = "2x Server Luck\n15m";
		Index = 1;
		Weight = 2;
	}};
	AltRewards = {-- : First try: K:0: attempt to index nil with 't'
;
}