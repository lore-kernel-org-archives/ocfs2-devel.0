From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 17 Oct 2020 14:01:22 -0700
Subject: [Ocfs2-devel] [RFC] treewide: cleanup unreachable breaks
In-Reply-To: <20201017160928.12698-1-trix@redhat.com>
References: <20201017160928.12698-1-trix@redhat.com>
Message-ID: <CAPcyv4jkSFxMXgMABX7sDbwmq8zJO=rLX2ww3Y9Tc0VAANY8xQ@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: trix@redhat.com
Cc: alsa-devel@alsa-project.org, clang-built-linux <clang-built-linux@googlegroups.com>, linux-iio@vger.kernel.org, nouveau@lists.freedesktop.org, storagedev@microchip.com, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, virtualization@lists.linux-foundation.org, "open list:KEYS-TRUSTED" <keyrings@vger.kernel.org>, linux-mtd@lists.infradead.org, ath10k@lists.infradead.org, linux-stm32@st-md-mailman.stormreply.com, usb-storage@lists.one-eyed-alien.net, linux-watchdog@vger.kernel.org, devel@driverdev.osuosl.org, linux-samsung-soc <linux-samsung-soc@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, amd-gfx list <amd-gfx@lists.freedesktop.org>, Linux ACPI <linux-acpi@vger.kernel.org>, intel-wired-lan@lists.osuosl.org, industrypack-devel@lists.sourceforge.net, Linux PCI <linux-pci@vger.kernel.org>, spice-devel@lists.freedesktop.org, MPT-FusionLinux.pdl@broadcom.com, "Linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, linux-serial@vger.kernel.org, linux-nfc@lists.01.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, linux-can@vger.kernel.org, linux-block@vger.kernel.org, linux-gpio@vger.kernel.org, xen-devel <xen-devel@lists.xenproject.org>, linux-amlogic@lists.infradead.org, openipmi-developer@lists.sourceforge.net, platform-driver-x86@vger.kernel.org, linux-integrity@vger.kernel.org, Linux ARM <linux-arm-kernel@lists.infradead.org>, linux-edac@vger.kernel.org, Netdev <netdev@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, Linux Wireless List <linux-wireless@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, linux-crypto <linux-crypto@vger.kernel.org>, patches@opensource.cirrus.com, bpf@vger.kernel.org, ocfs2-devel@oss.oracle.com, linux-power@fi.rohmeurope.com

On Sat, Oct 17, 2020 at 9:10 AM <trix@redhat.com> wrote:
>
> From: Tom Rix <trix@redhat.com>
>
> This is a upcoming change to clean up a new warning treewide.
> I am wondering if the change could be one mega patch (see below) or
> normal patch per file about 100 patches or somewhere half way by collecting
> early acks.
>
> clang has a number of useful, new warnings see
> https://urldefense.com/v3/__https://clang.llvm.org/docs/DiagnosticsReference.html__;!!GqivPVa7Brio!MpKp9ownetEZlweH32F6PVLvj9yWZG9B8S2TBEik09oCyu04Lj1YQIjcNXmBH7LnmP0oGA$ 
>
> This change cleans up -Wunreachable-code-break
> https://urldefense.com/v3/__https://clang.llvm.org/docs/DiagnosticsReference.html*wunreachable-code-break__;Iw!!GqivPVa7Brio!MpKp9ownetEZlweH32F6PVLvj9yWZG9B8S2TBEik09oCyu04Lj1YQIjcNXmBH7LEGxNISg$ 
> for 266 of 485 warnings in this week's linux-next, allyesconfig on x86_64.
>
> The method of fixing was to look for warnings where the preceding statement
> was a simple statement and by inspection made the subsequent break unneeded.
> In order of frequency these look like
>
> return and break
>
>         switch (c->x86_vendor) {
>         case X86_VENDOR_INTEL:
>                 intel_p5_mcheck_init(c);
>                 return 1;
> -               break;
>
> goto and break
>
>         default:
>                 operation = 0; /* make gcc happy */
>                 goto fail_response;
> -               break;
>
> break and break
>                 case COLOR_SPACE_SRGB:
>                         /* by pass */
>                         REG_SET(OUTPUT_CSC_CONTROL, 0,
>                                 OUTPUT_CSC_GRPH_MODE, 0);
>                         break;
> -                       break;
>
> The exception to the simple statement, is a switch case with a block
> and the end of block is a return
>
>                         struct obj_buffer *buff = r->ptr;
>                         return scnprintf(str, PRIV_STR_SIZE,
>                                         "size=%u\naddr=0x%X\n", buff->size,
>                                         buff->addr);
>                 }
> -               break;
>
> Not considered obvious and excluded, breaks after
> multi level switches
> complicated if-else if-else blocks
> panic() or similar calls
>
> And there is an odd addition of a 'fallthrough' in drivers/tty/nozomi.c
[..]
> diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
> index 5a7c80053c62..2f250874b1a4 100644
> --- a/drivers/nvdimm/claim.c
> +++ b/drivers/nvdimm/claim.c
> @@ -200,11 +200,10 @@ ssize_t nd_namespace_store(struct device *dev,
>                 }
>                 break;
>         default:
>                 len = -EBUSY;
>                 goto out_attach;
> -               break;
>         }

Acked-by: Dan Williams <dan.j.williams@intel.com>
