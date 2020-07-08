package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"strconv"
	"sync"
)

func main() {
	commandLineArguments := os.Args[1:]
	numCommandLineArguments := len(commandLineArguments)
	if numCommandLineArguments < 3 {
		fmt.Printf("Usage: %s [ip_address] [num_clients] [num_messages]", os.Args[0])
		return
	}

	num, err := strconv.ParseInt(commandLineArguments[1], 0, 0)
	if err != nil {
		fmt.Printf("Error parsing number of clients")
		return
	}

	numPort := 50
	startPort := 5440
	port := startPort
	endPort := startPort + numPort - 1
	serverIP := commandLineArguments[0]
	numMessages, err := strconv.ParseInt(commandLineArguments[2], 0, 0)
	if err != nil {
		println("Error parsing number of messages")
		return
	}

	var wg sync.WaitGroup
	wg.Add(int(num))
	for i := 0; i < int(num); i++ {

		go func(serverIP string, port int, senderID int, numMessages int64) {
			defer wg.Done()
			urlString := fmt.Sprintf("https://%s:%d/loadgenerator/exp0%d/%d", serverIP, port, senderID, numMessages)

			fmt.Printf("Fetching %s\n", urlString)
			resp, err := http.Get(urlString)
			if err != nil {
				fmt.Printf("%s\n", err)
			} else {
				body, err := ioutil.ReadAll(resp.Body)
				if err != nil {
					fmt.Printf("Error with reading body %s: %s\n", urlString, err)
				} else {
					println(string(body))
				}
				defer resp.Body.Close()
			}
		}(serverIP, port, i, numMessages)

		port++
		if port > endPort {
			port = startPort
		}
	}
	wg.Wait()
}
