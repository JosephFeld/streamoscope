import matplotlib.pyplot as plt
import numpy as np

def plot_fft_bodes(signals, fs, block=True, title="FFT Plot", plot_6db_line=False, center=None, bandwidth=None):
    # signal = signals[0]
    # Compute the FFT of the signal
    
    # Plot the magnitude
    plt.figure(figsize=(10, 6))
    for signal in signals:
        n = len(signal)  # Length of the signal
        fft_result = np.fft.fft(signal)
        fft_freqs = np.fft.fftfreq(n, d=1/fs)

        # Only keep the positive half of the spectrum
        positive_freqs = fft_freqs[:n//2]
        fft_magnitude = np.abs(fft_result[:n//2])
        fft_phase = np.angle(fft_result[:n//2])

        max_val = np.max(fft_magnitude[1:])
        minus_6db = max_val / 2.0

        print(max_val)
        print(positive_freqs[np.argmax(fft_magnitude)],np.argmax(fft_magnitude))

        resize_axes = center is not None and bandwidth is not None
        
        if resize_axes:
            xmin = center - bandwidth/2
            xmax = center + bandwidth/2
        

        plt.subplot(2, 1, 1)
        plt.semilogx(positive_freqs, 20 * np.log10(fft_magnitude),marker='o')
        plt.semilogx(positive_freqs, 20 * np.log10(max_val)*np.ones(fft_magnitude.shape)-6)

        if resize_axes:
            plt.xlim(xmin,xmax)
        
        plt.title(title)
        plt.ylabel('Magnitude (dB)')
        plt.grid(True)

        # Plot the phase
        plt.subplot(2, 1, 2)
        plt.semilogx(positive_freqs, np.degrees(fft_phase))

        if resize_axes:
            plt.xlim(xmin,xmax)
        
        plt.xlabel('Frequency (Hz)')
        plt.ylabel('Phase (degrees)')
        plt.grid(True)

        # Show the plots
    plt.tight_layout()
    plt.show()