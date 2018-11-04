From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Sun, 4 Nov 2018 07:52:18 +0000
Subject: [Ocfs2-devel] OCFS2: [ocfs2_rename:1688 ERROR: status = -39]
 with four syscalls on fresh FS image
In-Reply-To: <CAE5jQCeFs0_NS9AZwfw+U60jKU5RRPD56THEhCq_jLJkiFy0=A@mail.gmail.com>
References: <CAE5jQCeFs0_NS9AZwfw+U60jKU5RRPD56THEhCq_jLJkiFy0=A@mail.gmail.com>
Message-ID: <20181104075204.GD32577@ZenIV.linux.org.uk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Anatoly Trosinenko <anatoly.trosinenko@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

On Sun, Nov 04, 2018 at 10:37:34AM +0300, Anatoly Trosinenko wrote:
> Hello,
> 
> When fuzzing OCFS2, I got an ERROR message in dmesg output with
> several syscalls on completely fresh, uncrafted FS image. From this
> https://oss.oracle.com/pipermail/ocfs2-devel/2012-August/008683.html
> it looks like ERROR messages are indicating some unexpected conditions
> in the driver code, is it right? If so, here it how to reproduce it
> with kvm-xfstests:
> 
> 1) Checkout latest torvalds/master (tested with commit 71e56028), copy
> x86_64-config-4.14 from fstests to .config, `make olddefconfig`,
> enable CONFIG_FS then OCFS2 and compile
> 2) Create fresh OCFS2 image:
> $ fallocate -l 256M ocfs2
> $ mkfs.ocfs2 -L test --fs-features=local ./ocfs2
> $ mv ocfs2 /tmp/kvm-xfstests-$USER/ # mkfs.ocfs2 seems to not operate
> on tmpfs that can be mounted on /tmp
> 3) gcc --static ocfs2.c -o /tmp/kvm-xfstests-$USER/repro
> 4) Inside the ./kvm-xfstests shell
> root at kvm-xfstests:~# mount /vtmp
> root at kvm-xfstests:~# mount /vtmp/ocfs2 /mnt
> [   17.168634] JBD2: Ignoring recovery information on journal
> [   17.173903] ocfs2: Mounting device (7,0) on (node local, slot 0)
> with ordered data mode.
> root at kvm-xfstests:~# /vtmp/repro
> [   20.597145] (repro,368,1):ocfs2_rename:1688 ERROR: status = -39

That would be -ENOTEMPTY...

> root at kvm-xfstests:~#
> 
> Best regards
> Anatoly

> #include <sys/stat.h>
> #include <sys/types.h>
> #include <unistd.h>
> #include <stdio.h>
> 
> int main()
> {
>   mkdir("/mnt/xyz", 0x700);
>   mkdir("/mnt/abc", 0x700);
>   symlink("/mnt", "/mnt/xyz/1");
>   rename("/mnt/abc", "/mnt/xyz");

... and this would certainly warrant that - the victim is not empty, indeed.
AFAICS, ocfs2_rename() yells on _any_ error it's about to return.  Including
-EMLINK, etc.
