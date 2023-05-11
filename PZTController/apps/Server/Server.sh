#!/bin/bash 
 	until [ 1 = 2 ]; do
		./SensorBoard457Server
		./SensorBoard457Server 20458
 	done