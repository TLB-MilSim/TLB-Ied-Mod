# Steam Workshop assets

Everything needed to publish or update the Workshop page.

| File | Use |
|---|---|
| `description.bbcode` | The Workshop page body. Steam uses BBCode, not Markdown, so paste it as-is. |
| `preview.jpg` | Preview image, 1024×1024, 207 KB. |

## Title

```
TLB - IEDs
```

## Publishing

Upload with **Arma 3 Tools → Publisher**, pointing at the built `@TLB - IEDs`
folder from `dist\`. Build it first:

```powershell
.\build.ps1 -Package
```

## After the first upload

Three things live in the Workshop UI rather than in the description text, and
are easy to forget:

1. **Required Items.** Add **CBA_A3** and **ACE3** as dependencies. This is what
   makes the launcher pull them in automatically; naming them in the description
   does nothing on its own, and without it people will subscribe and get errors.
2. **Tags.** `Mod`, and whichever of `Object`, `Equipment` fit best.
3. **Video.** The demo can be attached to the page separately:
   https://youtu.be/1AH5ukcfTso

## Screenshots

Use the images in `../screenshots/`. The hero shot
(`01-mrap-in-crater.jpg`) makes the point of the mod faster than any paragraph,
so put it first, because Steam shows the first screenshot most prominently.

## Keep in sync

The description duplicates facts from the root `README.md`, namely requirements, the
class list, and the settings. When those change in one place, change them in the
other, or the Workshop page quietly starts lying about what the mod does.
