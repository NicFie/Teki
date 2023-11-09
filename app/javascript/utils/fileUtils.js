export const  patchForm = async (url, body) => {
    try {
        const response = await fetch(url, {
            body: body,
            method: 'PATCH',
            credentials: "include",
            headers: {
                "X-CSRF-Token": getCsrfToken(),
            },
        })
        const contentType = response.headers.get("content-type");
        if (!contentType || !contentType.includes("application/json")) {
            return null;
        }

        return await response.json();
    } catch (error) {
        console.log(error);
        throw error;
    }
}

export const postForm = async (url, body) => {
    try {
        const response = await fetch(url, {
            method: "POST",
            credentials: "same-origin",
            headers: {
                "X-CSRF-Token": getCsrfToken(),
                "Content-Type": "application/json",
                "Accept": "application/json"
            },
            body: JSON.stringify(body)
        });

        const contentType = response.headers.get("content-type");
        if (!contentType || !contentType.includes("application/json")) {
            return null;
        }

        return await response.json();
    } catch (error) {
        console.log(error);
        throw error;
    }
}

const getCsrfToken = () => {
    return document.getElementsByName('csrf-token')[0].content;
};