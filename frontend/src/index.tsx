import { h, render } from "preact";
import { ClientTable } from "./ClientTable";
import { ClientAddition } from "./ClientAddition";
import { useState, useEffect } from "preact/hooks";

const API_URL = "http://localhost:8080/";

export function App() {
  const [clients, setClients] = useState([]);

  // Function to fetch client data from the server and update the state
  const fetchClients = () => {
    fetch(API_URL + "get-clients")
      .then((response) => response.json())
      .then((data) => setClients(data.clients))
      .catch((error) => console.error("Error fetching clients:", error));
  };

  useEffect(() => {
    // Fetch client data when the component mounts
    fetchClients();
  }, []);

  // Function to handle client addition
  const handleAddClient = (newClient) => {
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
          fetchClients();
          console.log("Client added successfully");
        } else {
          console.error("Failed to add client");
        }
      })
      .catch((error) => {
        console.error("Error adding client:", error);
      });
  };

  const handleUpdateClient = (updatedClient) => {
    // Implement logic to update the client on the server
    console.log("Update client:", updatedClient);
  };

  const handleDeleteClient = (clientToDelete) => {
    // Implement logic to delete the client on the server
    console.log("Delete client:", clientToDelete);
  };

  return (
    <div>
      <h1>Hat Trick</h1>
      <ClientAddition onSubmit={handleAddClient} />
      <ClientTable clients={clients} onRefresh={fetchClients} onUpdate={handleUpdateClient} onDelete={handleDeleteClient} />
    </div>
  );
}
render(<App />, document.getElementById("app"));
