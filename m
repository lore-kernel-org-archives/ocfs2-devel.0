From: Tom Rix <trix@redhat.com>
Date: Tue, 20 Oct 2020 07:09:23 -0700
Subject: [Ocfs2-devel] [RFC] treewide: cleanup unreachable breaks
In-Reply-To: <20201019230546.GH36674@ziepe.ca>
References: <20201017160928.12698-1-trix@redhat.com>
	<20201018054332.GB593954@kroah.com>
	<CAKwvOdkR_Ttfo7_JKUiZFVqr=Uh=4b05KCPCSuzwk=zaWtA2_Q@mail.gmail.com>
	<20201019230546.GH36674@ziepe.ca>
Message-ID: <859ff6ff-3e10-195c-6961-7b2902b151d4@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgg@ziepe.ca>, Nick Desaulniers <ndesaulniers@google.com>
Cc: alsa-devel@alsa-project.org, clang-built-linux <clang-built-linux@googlegroups.com>, Greg KH <gregkh@linuxfoundation.org>, linux-iio@vger.kernel.org, nouveau@lists.freedesktop.org, storagedev@microchip.com, dri-devel <dri-devel@lists.freedesktop.org>, virtualization@lists.linux-foundation.org, keyrings@vger.kernel.org, linux-mtd@lists.infradead.org, ath10k@lists.infradead.org, linux-stm32@st-md-mailman.stormreply.com, usb-storage@lists.one-eyed-alien.net, linux-watchdog@vger.kernel.org, devel@driverdev.osuosl.org, linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvdimm <linux-nvdimm@lists.01.org>, amd-gfx list <amd-gfx@lists.freedesktop.org>, linux-acpi@vger.kernel.org, intel-wired-lan@lists.osuosl.org, industrypack-devel@lists.sourceforge.net, linux-pci@vger.kernel.org, spice-devel@lists.freedesktop.org, MPT-FusionLinux.pdl@broadcom.com, linux-media@vger.kernel.org, linux-serial@vger.kernel.org, linux-nfc@lists.01.org, linux-pm@vger.kernel.org, linux-can@vger.kernel.org, linux-block@vger.kernel.org, linux-gpio@vger.kernel.org, xen-devel@lists.xenproject.org, linux-amlogic@lists.infradead.org, openipmi-developer@lists.sourceforge.net, platform-driver-x86@vger.kernel.org, linux-integrity@vger.kernel.org, Linux ARM <linux-arm-kernel@lists.infradead.org>, linux-edac@vger.kernel.org, George Burgess <gbiv@google.com>, Network Development <netdev@vger.kernel.org>, linux-usb@vger.kernel.org, linux-wireless <linux-wireless@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, patches@opensource.cirrus.com, bpf <bpf@vger.kernel.org>, ocfs2-devel@oss.oracle.com, linux-power@fi.rohmeurope.com


On 10/19/20 4:05 PM, Jason Gunthorpe wrote:
> On Mon, Oct 19, 2020 at 12:42:15PM -0700, Nick Desaulniers wrote:
>> On Sat, Oct 17, 2020 at 10:43 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>>> On Sat, Oct 17, 2020 at 09:09:28AM -0700, trix at redhat.com wrote:
>>>> From: Tom Rix <trix@redhat.com>
>>>>
>>>> This is a upcoming change to clean up a new warning treewide.
>>>> I am wondering if the change could be one mega patch (see below) or
>>>> normal patch per file about 100 patches or somewhere half way by collecting
>>>> early acks.
>>> Please break it up into one-patch-per-subsystem, like normal, and get it
>>> merged that way.
>>>
>>> Sending us a patch, without even a diffstat to review, isn't going to
>>> get you very far...
>> Tom,
>> If you're able to automate this cleanup, I suggest checking in a
>> script that can be run on a directory.  Then for each subsystem you
>> can say in your commit "I ran scripts/fix_whatever.py on this subdir."
>>  Then others can help you drive the tree wide cleanup.  Then we can
>> enable -Wunreachable-code-break either by default, or W=2 right now
>> might be a good idea.
> I remember using clang-modernize in the past to fix issues very
> similar to this, if clang machinery can generate the warning, can't
> something like clang-tidy directly generate the patch?

Yes clang-tidy and similar are good tools.

Sometimes they change too much and your time shifts

from editing to analyzing and dropping changes.


I am looking at them for auto changing api.

When i have something greater than half baked i will post.

Tom

>
> You can send me a patch for drivers/infiniband/* as well
>
> Thanks,
> Jason
>
