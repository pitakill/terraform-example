package main

import (
	"net/http"
	"net/http/httptest"
	"reflect"
	"testing"
)

func TestServer(t *testing.T) {
	req, err := http.NewRequest("GET", "/", nil)
	if err != nil {
		t.Errorf("An error occurred %v", err)
	}

	rr := httptest.NewRecorder()

	http.HandlerFunc(root).ServeHTTP(rr, req)

	if status := rr.Code; status != http.StatusOK {
		t.Errorf("Status code differs. Expected %d.\nGot %d instead", http.StatusOK, status)
	}

	expected := ":-P"

	if !reflect.DeepEqual(expected, rr.Body.String()) {
		t.Errorf("Response differs. Expected %s.\nGot %s instead", expected, rr.Body.String())
	}
}
