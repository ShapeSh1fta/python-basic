function timeoutPromise(promise: Promise<any>, timeout: number) {
    return new Promise(
        async (resolve, reject) => {
            const timeoutId = setTimeout(() => {
                clearTimeout(timeoutId);
                reject(new Error('Promise timed out'));
            }, timeout);

            try {
                const result = await promise;
                clearTimeout(timeoutId);
                resolve(result);
            }
            catch (error) {
                clearTimeout(timeoutId);
                reject(error);
            }
        }
    );
}

async function fetchWithAbort(url: string, options: object = {}, timeout: number = 5000) : Promise<Response>{
    const controller = new AbortController();
    const signal = controller.signal;

    const timeoutId = setTimeout(() => controller.abort(), timeout);

    try {
        const response = await fetch(url, { ...options, signal });
        clearTimeout(timeoutId); // Clear the timeout if the fetch succeeds
        return response; // Return the response if it completes before the timeout
    } catch (error: unknown) {
        // Properly type guard the error to check what type of error it is
        if (error instanceof DOMException && error.name === "AbortError") {
            throw new Error("Fetch request timed out");
        } else if (error instanceof TypeError) {
            throw new Error("Network error or fetch failure");
        } else {
            throw error; // Rethrow other unexpected errors
        }
    }
};

export {
    timeoutPromise,
    fetchWithAbort
}