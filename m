From: Emanuele Giuseppe Esposito <eesposit@redhat.com>
Date: Tue, 21 Apr 2020 13:26:43 +0200
Subject: [Ocfs2-devel] [PATCH 2/8] fs: extract simple_pin/release_fs to
	separate files
In-Reply-To: <7abfdd3b-dbbe-52ab-df53-95e9f86d39cd@linux.ibm.com>
References: <20200414124304.4470-1-eesposit@redhat.com>
	<20200414124304.4470-3-eesposit@redhat.com>
	<7abfdd3b-dbbe-52ab-df53-95e9f86d39cd@linux.ibm.com>
Message-ID: <0d33b363-3801-8147-6f49-f1d6a845fdaf@redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Frederic Barrat <fbarrat@linux.ibm.com>, linux-nfs@vger.kernel.org
Cc: Song Liu <songliubraving@fb.com>, linux-usb@vger.kernel.org, bpf@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>, David Airlie <airlied@linux.ie>, Heiko Carstens <heiko.carstens@de.ibm.com>, Alexei Starovoitov <ast@kernel.org>, dri-devel@lists.freedesktop.org, "J. Bruce Fields" <bfields@fieldses.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, Paul Mackerras <paulus@samba.org>, John Johansen <john.johansen@canonical.com>, linux-s390@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Andrew Donnellan <ajd@linux.ibm.com>, Matthew Garrett <matthew.garrett@nebula.com>, linux-efi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, Daniel Borkmann <daniel@iogearbox.net>, Christian Borntraeger <borntraeger@de.ibm.com>, linux-rdma@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>, Mark Fasheh <mark@fasheh.com>, Anton Vorontsov <anton@enomsg.org>, John Fastabend <john.fastabend@gmail.com>, James Morris <jmorris@namei.org>, Ard Biesheuvel <ardb@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, oprofile-list@lists.sf.net, Yonghong Song <yhs@fb.com>, Ian Kent <raven@themaw.net>, Andrii Nakryiko <andriin@fb.com>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, netdev@vger.kernel.org, Robert Richter <rric@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, Vasily Gorbik <gor@linux.ibm.com>, Tony Luck <tony.luck@intel.com>, Kees Cook <keescook@chromium.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, autofs@vger.kernel.org, Uma Krishnan <ukrishn@linux.ibm.com>, "Manoj N. Kumar" <manoj@linux.ibm.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jakub Kicinski <kuba@kernel.org>, KP Singh <kpsingh@chromium.org>, Trond Myklebust <trond.myklebust@hammerspace.com>, "Matthew R. Ochs" <mrochs@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, Felipe Balbi <balbi@kernel.org>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Iurii Zaikin <yzaikin@google.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Anna Schumaker <anna.schumaker@netapp.com>, Luis Chamberlain <mcgrof@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, Jeremy Kerr <jk@ozlabs.org>, Colin Cross <ccross@android.com>, linux-fsdevel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Mike Kravetz <mike.kravetz@oracle.com>, linuxppc-dev@lists.ozlabs.org, Martin KaFai Lau <kafai@fb.com>, ocfs2-devel@oss.oracle.com, Joel Becker <jlbec@evilplan.org>



On 4/21/20 1:19 PM, Frederic Barrat wrote:
> 
> 
>> diff --git a/drivers/misc/cxl/Kconfig b/drivers/misc/cxl/Kconfig
>> index 39eec9031487..a62795079d9c 100644
>> --- a/drivers/misc/cxl/Kconfig
>> +++ b/drivers/misc/cxl/Kconfig
>> @@ -19,6 +19,7 @@ config CXL
>> ????? select CXL_BASE
>> ????? select CXL_AFU_DRIVER_OPS
>> ????? select CXL_LIB
>> +??? select SIMPLEFS
>> ????? default m
>> ????? help
>> ??????? Select this option to enable driver support for IBM Coherent
>> diff --git a/drivers/misc/cxl/api.c b/drivers/misc/cxl/api.c
>> index b493de962153..0b8f8de7475a 100644
>> --- a/drivers/misc/cxl/api.c
>> +++ b/drivers/misc/cxl/api.c
>> @@ -9,6 +9,7 @@
>> ? #include <misc/cxl.h>
>> ? #include <linux/module.h>
>> ? #include <linux/mount.h>
>> +#include <linux/simplefs.h>
>> ? #include <linux/pseudo_fs.h>
>> ? #include <linux/sched/mm.h>
>> ? #include <linux/mmu_context.h>
>> diff --git a/drivers/misc/ocxl/Kconfig b/drivers/misc/ocxl/Kconfig
>> index 2d2266c1439e..ddd9245fff3d 100644
>> --- a/drivers/misc/ocxl/Kconfig
>> +++ b/drivers/misc/ocxl/Kconfig
>> @@ -12,6 +12,7 @@ config OCXL
>> ????? depends on PPC_POWERNV && PCI && EEH
>> ????? select OCXL_BASE
>> ????? select HOTPLUG_PCI_POWERNV
>> +??? select SIMPLEFS
> 
> 
> It's not clear to me the Kconfig updated is needed for the ocxl driver. 
> I think it's only needed for the cxl driver.

I am going to get rid of the separate simplefs.c file and related 
Kconfig entry and put everything in fs/libfs.c, so this file (together 
with many others touched in this patch) won't be modified in v2.

Thanks,

Emanuele
