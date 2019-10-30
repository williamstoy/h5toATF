# h5toATF
Converts WaveSurfer (HDF5, .h5) data files to Axon Text Files (ATF, .atf) for analysis in Clampfit

**Currently only works on episodic recordings**

## Requirements:
- [Matlab](https://www.mathworks.com/products/matlab.html) (Paid, Free trial available)
- [Wavesurfer](https://www.janelia.org/open-science/wavesurfer) (Free)
- [Clampfit](http://mdc.custhelp.com/app/answers/detail/a_id/20260/~/axon%E2%84%A2-pclamp%E2%84%A2-11-electrophysiology-data-acquisition-%26-analysis-software) (Included free with pClamp 11, no need to purchase pClamp to use Clampfit)


## Demo
```
ConvertAllWsToAtf(true, true)
```

Converts all Wavesurfer files in current folder from .h5 to .atf
- first argument: overwrite exiting files with the same name
- second argumetn: open converted files in clampfit when conversion finishes

Converts all files in the current folder from .h5 to .atf