import { h, render } from "preact";
import { ClientTable } from "./ClientTable";
import { ClientAddition } from "./ClientAddition";
import { useState, useEffect } from "preact/hooks";
import { getClients, addClient, updateClient, deleteClient } from "./clientServices"; // Import the service functions

export function App() {
  const [clients, setClients] = useState([]);

  useEffect(() => {
    getClients()
      .then((data) => setClients(data.clients))
      .catch((error) => console.error("Error fetching clients:", error));
  }, []);

  const handleAddClient = (newClient) => {
    addClient(newClient)
      .then((data) => setClients(data.clients))
      .catch((error) => console.error("Error adding client:", error));
  };

  const handleUpdateClient = (updatedClient) => {
    updateClient(updatedClient)
      .then((data) => setClients(data.clients))
      .catch((error) => console.error("Error updating client:", error));
  };

  const handleDeleteClient = (clientToDelete) => {
    deleteClient(clientToDelete)
      .then((data) => setClients(data.clients))
      .catch((error) => console.error("Error deleting client:", error));
  };

  return (
    <div>
      <h1>Hat Trick</h1>
      <ClientAddition onSubmit={handleAddClient} />
      <ClientTable clients={clients} onRefresh={getClients} onUpdate={handleUpdateClient} onDelete={handleDeleteClient} />
    </div>
  );
}

render(<App />, document.getElementById("app"));
