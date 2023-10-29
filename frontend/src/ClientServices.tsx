const API_URL = import.meta.env.VITE_REACT_APP_API_URL;

export const getClients = () => {
  return fetch(API_URL + "get-clients")
    .then((response) => response.json())
    .catch((error) => {
      console.error("Error fetching clients: ", error);
      throw error;
    });
};

export const addClient = (newClient) => {
  return fetch(API_URL + "add-client", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(newClient),
  })
    .then((response) => {
      if (!response.ok) {
        console.error("Failed to create client: ", response.status, response.statusText);
        return;
      }
      console.log("Client created successfully");
      return getClients();
    })
    .catch((error) => {
      console.error("Error adding client:", error);
      throw error;
    });
};

export const updateClient = (updatedClient) => {
  return fetch(API_URL + "update-client", {
    method: "PUT",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(updatedClient),
  })
    .then((response) => {
      if (!response.ok) {
        console.error("Failed to update client: ", response.status, response.statusText);
        return;
      }
      console.log("Client updated successfully");
      return getClients();
    })
    .catch((error) => {
      console.error("Error updating client:", error);
      throw error;
    });
};

export const deleteClient = (clientToDelete) => {
  return fetch(API_URL + "delete-client", {
    method: "DELETE",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(clientToDelete),
  })
    .then((response) => {
      if (!response.ok) {
        console.error("Failed to delete client: ", response.status, response.statusText);
        return;
      }
      console.log("Client deleted successfully");
      return getClients();
    })
    .catch((error) => {
      console.error("Error deleting client:", error);
      throw error;
    });
};
