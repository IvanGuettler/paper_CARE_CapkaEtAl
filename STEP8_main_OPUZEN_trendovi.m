close all; clear all; clc

pkg load statistics

load ZaTrendove_2016-11-18.mat


	TablicaT2m =nan(20,6);
	TablicaT2mS=nan(20,6);
	MODn=[2,1,3];
	TIPn=[1,7];
	for TIME=1:5;
	
	    if (TIME==5)
		for TIP=[1:2]
		for MOD=[1:3]
	        ulaz=matrica_YM(11:65,MODn(MOD)+TIPn(TIP));
	                clear dekLin dekSen pravac linPrav pValue taubSig
			[dekLin,dekSen,pravac,linPrav,pValue,taubSig]=TrendRez(ulaz,1);
		TablicaT2m(17,MOD+3*(TIP-1))=round(dekLin*100)/100; 
		TablicaT2m(18,MOD+3*(TIP-1))=round(dekSen*100)/100;
		clear H PP
		[H,PP]=MannKendall(ulaz,0.05);
		TablicaT2mS(17,MOD+3*(TIP-1))=H; 
		TablicaT2mS(18,MOD+3*(TIP-1))=taubSig;

	        ulaz=matrica_YM(1:100,MODn(MOD)+TIPn(TIP));
	                clear dekLin dekSen pravac linPrav pValue taubSig
			[dekLin,dekSen,pravac,linPrav,pValue,taubSig]=TrendRez(ulaz,1);
		TablicaT2m(19,MOD+3*(TIP-1))=round(dekLin*100)/100; 
		TablicaT2m(20,MOD+3*(TIP-1))=round(dekSen*100)/100;
		clear H PP
		[H,PP]=MannKendall(ulaz,0.05);
		TablicaT2mS(19,MOD+3*(TIP-1))=H; 
		TablicaT2mS(20,MOD+3*(TIP-1))=taubSig;
		end %MOD
		end %TIP
	    end %TIME if
	    if (TIME<5)
		for TIP=[1:2]
		for MOD=[1:3]
	        ulaz=matrica_SM(11:65,MODn(MOD)+TIPn(TIP),TIME);
	                clear dekLin dekSen pravac linPrav pValue taubSig
			[dekLin,dekSen,pravac,linPrav,pValue,taubSig]=TrendRez(ulaz,1);
		TablicaT2m(1+4*(TIME-1),MOD+3*(TIP-1))=round(dekLin*100)/100; 
		TablicaT2m(2+4*(TIME-1),MOD+3*(TIP-1))=round(dekSen*100)/100;
		clear H PP
		[H,PP]=MannKendall(ulaz,0.05);
		TablicaT2mS(1+4*(TIME-1),MOD+3*(TIP-1))=H; 
		TablicaT2mS(2+4*(TIME-1),MOD+3*(TIP-1))=taubSig;

	        ulaz=matrica_SM(1:100,MODn(MOD)+TIPn(TIP),TIME);
	                clear dekLin dekSen pravac linPrav pValue taubSig
			[dekLin,dekSen,pravac,linPrav,pValue,taubSig]=TrendRez(ulaz,1);
		TablicaT2m(3+4*(TIME-1),MOD+3*(TIP-1))=round(dekLin*100)/100; 
		TablicaT2m(4+4*(TIME-1),MOD+3*(TIP-1))=round(dekSen*100)/100;
		clear H PP
		[H,PP]=MannKendall(ulaz,0.05);
		TablicaT2mS(3+4*(TIME-1),MOD+3*(TIP-1))=H; 
		TablicaT2mS(4+4*(TIME-1),MOD+3*(TIP-1))=taubSig;
		end %MOD
		end %TIP
	    end %TIME if
	end %TIME for


	TablicaR =nan(20,9);
	TablicaRS=nan(20,9);
	MODn=[2,1,3];
	TIPn=[4,10,13]
	for TIME=1:5;
	
	    if (TIME==5)
		for TIP=[1:3]
		for MOD=[1:3]
	        ulaz=matrica_YM(11:65,MODn(MOD)+TIPn(TIP));
	                clear dekLin dekSen pravac linPrav pValue taubSig
			[dekLin,dekSen,pravac,linPrav,pValue,taubSig]=TrendRez(ulaz,1);
		TablicaR(17,MOD+3*(TIP-1))=round(dekLin*100)/100; 
		TablicaR(18,MOD+3*(TIP-1))=round(dekSen*100)/100;
		clear H PP
		[H,PP]=MannKendall(ulaz,0.05);
		TablicaRS(17,MOD+3*(TIP-1))=H; 
		TablicaRS(18,MOD+3*(TIP-1))=taubSig;

	        ulaz=matrica_YM(1:100,MODn(MOD)+TIPn(TIP));
	                clear dekLin dekSen pravac linPrav pValue taubSig
			[dekLin,dekSen,pravac,linPrav,pValue,taubSig]=TrendRez(ulaz,1);
		TablicaR(19,MOD+3*(TIP-1))=round(dekLin*100)/100; 
		TablicaR(20,MOD+3*(TIP-1))=round(dekSen*100)/100;
		clear H PP
		[H,PP]=MannKendall(ulaz,0.05);
		TablicaRS(19,MOD+3*(TIP-1))=H; 
		TablicaRS(20,MOD+3*(TIP-1))=taubSig;
		end %MOD
		end %TIP
	    end %TIME if
	    if (TIME<5)
		for TIP=[1:3]
		for MOD=[1:3]
	        ulaz=matrica_SM(11:65,MODn(MOD)+TIPn(TIP),TIME);
	                clear dekLin dekSen pravac linPrav pValue taubSig
			[dekLin,dekSen,pravac,linPrav,pValue,taubSig]=TrendRez(ulaz,1);
		TablicaR(1+4*(TIME-1),MOD+3*(TIP-1))=round(dekLin*100)/100; 
		TablicaR(2+4*(TIME-1),MOD+3*(TIP-1))=round(dekSen*100)/100;
		clear H PP
		[H,PP]=MannKendall(ulaz,0.05);
		TablicaRS(1+4*(TIME-1),MOD+3*(TIP-1))=H; 
		TablicaRS(2+4*(TIME-1),MOD+3*(TIP-1))=taubSig;

	        ulaz=matrica_SM(1:100,MODn(MOD)+TIPn(TIP),TIME);
	                clear dekLin dekSen pravac linPrav pValue taubSig
			[dekLin,dekSen,pravac,linPrav,pValue,taubSig]=TrendRez(ulaz,1);
		TablicaR(3+4*(TIME-1),MOD+3*(TIP-1))=round(dekLin*100)/100; 
		TablicaR(4+4*(TIME-1),MOD+3*(TIP-1))=round(dekSen*100)/100;
		clear H PP
		[H,PP]=MannKendall(ulaz,0.05);
		TablicaRS(3+4*(TIME-1),MOD+3*(TIP-1))=H; 
		TablicaRS(4+4*(TIME-1),MOD+3*(TIP-1))=taubSig;
		end %MOD
		end %TIP
	    end %TIME if
	end %TIME for




