import { toast, ToastOptions } from 'react-toastify';

// Toast configuration
const defaultOptions: ToastOptions = {
  position: 'top-right',
  autoClose: 4000,
  hideProgressBar: false,
  closeOnClick: true,
  pauseOnHover: true,
  draggable: true,
  theme: 'dark',
};

// Success toast
export const showSuccess = (message: string, options?: ToastOptions) => {
  toast.success(message, { ...defaultOptions, ...options });
};

// Error toast
export const showError = (message: string, options?: ToastOptions) => {
  toast.error(message, { ...defaultOptions, ...options });
};

// Info toast
export const showInfo = (message: string, options?: ToastOptions) => {
  toast.info(message, { ...defaultOptions, ...options });
};

// Warning toast
export const showWarning = (message: string, options?: ToastOptions) => {
  toast.warning(message, { ...defaultOptions, ...options });
};

// Confirm dialog using toast
export const showConfirm = (
  message: string,
  onConfirm: () => void,
  onCancel?: () => void,
): void => {
  toast(
    ({ closeToast }) => (
      <div className="flex flex-col gap-3">
        <p className="text-white font-medium">{message}</p>
        <div className="flex gap-2 justify-end">
          <button
            onClick={() => {
              closeToast();
              onCancel?.();
            }}
            className="px-4 py-2 bg-gray-600 hover:bg-gray-700 text-white rounded-lg text-sm font-medium transition-colors"
          >
            ยกเลิก
          </button>
          <button
            onClick={() => {
              closeToast();
              onConfirm();
            }}
            className="px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded-lg text-sm font-medium transition-colors"
          >
            ยืนยัน
          </button>
        </div>
      </div>
    ),
    {
      ...defaultOptions,
      autoClose: false,
      closeOnClick: false,
      closeButton: true,
    },
  );
};

