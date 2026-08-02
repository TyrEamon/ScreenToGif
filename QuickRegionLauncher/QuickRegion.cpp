#include <shellapi.h>
#include <windows.h>
#include <cwchar>

int WINAPI wWinMain(HINSTANCE, HINSTANCE, PWSTR, int)
{
    wchar_t executablePath[MAX_PATH];
    const auto length = GetModuleFileNameW(nullptr, executablePath, MAX_PATH);

    if (length == 0 || length == MAX_PATH)
        return 1;

    auto separator = wcsrchr(executablePath, L'\\');

    if (separator == nullptr)
        return 1;

    *(separator + 1) = L'\0';
    wchar_t workingDirectory[MAX_PATH];

    if (wcscpy_s(workingDirectory, executablePath) != 0)
        return 1;

    if (wcscat_s(executablePath, L"ScreenToGif.exe") != 0)
        return 1;

    const auto result = ShellExecuteW(nullptr, L"open", executablePath, L"-quick-region", workingDirectory, SW_SHOWNORMAL);
    return reinterpret_cast<INT_PTR>(result) > 32 ? 0 : 1;
}
