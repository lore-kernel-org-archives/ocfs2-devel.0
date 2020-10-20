From: John Haxby <john.haxby@oracle.com>
Date: Tue, 20 Oct 2020 09:47:45 +0100
Subject: [Ocfs2-devel] [RFC] treewide: cleanup unreachable breaks
In-Reply-To: <CAKwvOdkR_Ttfo7_JKUiZFVqr=Uh=4b05KCPCSuzwk=zaWtA2_Q@mail.gmail.com>
References: <20201017160928.12698-1-trix@redhat.com>
	<20201018054332.GB593954@kroah.com>
	<CAKwvOdkR_Ttfo7_JKUiZFVqr=Uh=4b05KCPCSuzwk=zaWtA2_Q@mail.gmail.com>
Message-ID: <27A23102-A7F5-48C5-8972-48CE4C283C6E@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: alsa-devel@alsa-project.org, linux-usb@vger.kernel.org, linux-iio@vger.kernel.org, Tom Rix <trix@redhat.com>, linux-pci@vger.kernel.org, dri-devel <dri-devel@lists.freedesktop.org>, virtualization@lists.linux-foundation.org, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, amd-gfx list <amd-gfx@lists.freedesktop.org>, linux-stm32@st-md-mailman.stormreply.com, usb-storage@lists.one-eyed-alien.net, devel@driverdev.osuosl.org, linux-samsung-soc@vger.kernel.org, xen-devel@lists.xenproject.org, linux-scsi@vger.kernel.org, clang-built-linux <clang-built-linux@googlegroups.com>, linux-pm@vger.kernel.org, ath10k@lists.infradead.org, linux-acpi@vger.kernel.org, intel-wired-lan@lists.osuosl.org, industrypack-devel@lists.sourceforge.net, nouveau@lists.freedesktop.org, spice-devel@lists.freedesktop.org, MPT-FusionLinux.pdl@broadcom.com, linux-media@vger.kernel.org, linux-watchdog@vger.kernel.org, linux-nfc@lists.01.org, linux-serial@vger.kernel.org, linux-can@vger.kernel.org, linux-block@vger.kernel.org, linux-gpio@vger.kernel.org, storagedev@microchip.com, linux-amlogic@lists.infradead.org, openipmi-developer@lists.sourceforge.net, platform-driver-x86@vger.kernel.org, bpf <bpf@vger.kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, linux-edac@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-wireless <linux-wireless@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, George Burgess <gbiv@google.com>, Network Development <netdev@vger.kernel.org>, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, linux-integrity@vger.kernel.org, patches@opensource.cirrus.com, ocfs2-devel@oss.oracle.com, linux-power@fi.rohmeurope.com



> On 19 Oct 2020, at 20:42, Nick Desaulniers <ndesaulniers@google.com> wrote:
> 
> We probably should add all 3 to W=2 builds (wrapped in cc-option).
> I've filed https://github.com/ClangBuiltLinux/linux/issues/1180 to
> follow up on.

It looks as though the URL mangling has been fixed.   If anyone sees that specific URL mangled, please let me know.

jch
-------------- next part --------------
A non-text attachment was scrubbed...
Name: signature.asc
Type: application/pgp-signature
Size: 268 bytes
Desc: Message signed with OpenPGP
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20201020/094f0e00/attachment-0001.bin 
