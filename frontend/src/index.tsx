import { h, render } from "preact";
import { ClientTable } from "./ClientTable";
import { ClientAddition } from "./ClientAddition";

const API_URL = "http://localhost:8080/";

export function App() {
  // Define a function to handle client addition
  const handleAddClient = (newClient) => {
    // Send a POST request to your backend API to add the client
    fetch(API_URL + "add-client", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(newClient),
    })
      .then((response) => {
        if (response.ok) {
          // If the request is successful, refresh the client list
          // or perform any other necessary actions
          console.log("Client added successfully");
        } else {
          console.error("Failed to add client");
        }
      })
      .catch((error) => {
        console.error("Error adding client:", error);
      });
  };

  return (
    <div>
      <h1>Hat Trick</h1>
      <ClientAddition onSubmit={handleAddClient} />
      <ClientTable />
    </div>
  );
}

render(<App />, document.getElementById("app"));
