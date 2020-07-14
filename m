From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Tue, 14 Jul 2020 13:14:11 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Replace HTTP links with HTTPS ones
In-Reply-To: <20200713174456.36596-1-grandmaster@al2klimov.de>
References: <20200713174456.36596-1-grandmaster@al2klimov.de>
Message-ID: <d1f15c7c-d1c5-f87a-4d51-ed55a258dae4@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Alexander A. Klimov" <grandmaster@al2klimov.de>, mark@fasheh.com, jlbec@evilplan.org, corbet@lwn.net, ocfs2-devel@oss.oracle.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org



On 2020/7/14 01:44, Alexander A. Klimov wrote:
> Rationale:
> Reduces attack surface on kernel devs opening the links for MITM
> as HTTPS traffic is much harder to manipulate.
> 
> Deterministic algorithm:
> For each file:
>   If not .svg:
>     For each line:
>       If doesn't contain `\bxmlns\b`:
>         For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
> 	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
>             If both the HTTP and HTTPS versions
>             return 200 OK and serve the same content:
>               Replace HTTP with HTTPS.
> 
> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>

Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  Continuing my work started at 93431e0607e5.
>  See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
>  (Actually letting a shell for loop submit all this stuff for me.)
> 
>  If there are any URLs to be removed completely or at least not just HTTPSified:
>  Just clearly say so and I'll *undo my change*.
>  See also: https://urldefense.com/v3/__https://lkml.org/lkml/2020/6/27/64__;!!GqivPVa7Brio!KcDKP3qB9qOXyB3f-1-Jse08v44QPm7REvV1-Ff83lbAVpV1HBZ8jAtq9cJQwzYieIwIQg$ 
> 
>  If there are any valid, but yet not changed URLs:
>  See: https://urldefense.com/v3/__https://lkml.org/lkml/2020/6/26/837__;!!GqivPVa7Brio!KcDKP3qB9qOXyB3f-1-Jse08v44QPm7REvV1-Ff83lbAVpV1HBZ8jAtq9cJQwzY0M1Vvzw$ 
> 
>  If you apply the patch, please let me know.
> 
>  Sorry again to all maintainers who complained about subject lines.
>  Now I realized that you want an actually perfect prefixes,
>  not just subsystem ones.
>  I tried my best...
>  And yes, *I could* (at least half-)automate it.
>  Impossible is nothing! :)
> 
> 
>  Documentation/filesystems/dlmfs.rst | 2 +-
>  Documentation/filesystems/ocfs2.rst | 2 +-
>  fs/ocfs2/Kconfig                    | 6 +++---
>  fs/ocfs2/blockcheck.c               | 2 +-
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/filesystems/dlmfs.rst b/Documentation/filesystems/dlmfs.rst
> index 68daaa7facf9..28dd41a63be2 100644
> --- a/Documentation/filesystems/dlmfs.rst
> +++ b/Documentation/filesystems/dlmfs.rst
> @@ -12,7 +12,7 @@ dlmfs is built with OCFS2 as it requires most of its infrastructure.
>  
>  :Project web page:    https://urldefense.com/v3/__http://ocfs2.wiki.kernel.org__;!!GqivPVa7Brio!KcDKP3qB9qOXyB3f-1-Jse08v44QPm7REvV1-Ff83lbAVpV1HBZ8jAtq9cJQwzbm8qQnig$ 
>  :Tools web page:      https://urldefense.com/v3/__https://github.com/markfasheh/ocfs2-tools__;!!GqivPVa7Brio!KcDKP3qB9qOXyB3f-1-Jse08v44QPm7REvV1-Ff83lbAVpV1HBZ8jAtq9cJQwzacUS1QHw$ 
> -:OCFS2 mailing lists: http://oss.oracle.com/projects/ocfs2/mailman/
> +:OCFS2 mailing lists: https://oss.oracle.com/projects/ocfs2/mailman/
>  
>  All code copyright 2005 Oracle except when otherwise noted.
>  
> diff --git a/Documentation/filesystems/ocfs2.rst b/Documentation/filesystems/ocfs2.rst
> index 412386bc6506..42ca9a3d4c6e 100644
> --- a/Documentation/filesystems/ocfs2.rst
> +++ b/Documentation/filesystems/ocfs2.rst
> @@ -14,7 +14,7 @@ get "mount.ocfs2" and "ocfs2_hb_ctl".
>  
>  Project web page:    https://urldefense.com/v3/__http://ocfs2.wiki.kernel.org__;!!GqivPVa7Brio!KcDKP3qB9qOXyB3f-1-Jse08v44QPm7REvV1-Ff83lbAVpV1HBZ8jAtq9cJQwzbm8qQnig$ 
>  Tools git tree:      https://urldefense.com/v3/__https://github.com/markfasheh/ocfs2-tools__;!!GqivPVa7Brio!KcDKP3qB9qOXyB3f-1-Jse08v44QPm7REvV1-Ff83lbAVpV1HBZ8jAtq9cJQwzacUS1QHw$ 
> -OCFS2 mailing lists: http://oss.oracle.com/projects/ocfs2/mailman/
> +OCFS2 mailing lists: https://oss.oracle.com/projects/ocfs2/mailman/
>  
>  All code copyright 2005 Oracle except when otherwise noted.
>  
> diff --git a/fs/ocfs2/Kconfig b/fs/ocfs2/Kconfig
> index aca16624b370..5d11380d8724 100644
> --- a/fs/ocfs2/Kconfig
> +++ b/fs/ocfs2/Kconfig
> @@ -16,9 +16,9 @@ config OCFS2_FS
>  	  You'll want to install the ocfs2-tools package in order to at least
>  	  get "mount.ocfs2".
>  
> -	  Project web page:    http://oss.oracle.com/projects/ocfs2
> -	  Tools web page:      http://oss.oracle.com/projects/ocfs2-tools
> -	  OCFS2 mailing lists: http://oss.oracle.com/projects/ocfs2/mailman/
> +	  Project web page:    https://oss.oracle.com/projects/ocfs2
> +	  Tools web page:      https://oss.oracle.com/projects/ocfs2-tools
> +	  OCFS2 mailing lists: https://oss.oracle.com/projects/ocfs2/mailman/
>  
>  	  For more information on OCFS2, see the file
>  	  <file:Documentation/filesystems/ocfs2.rst>.
> diff --git a/fs/ocfs2/blockcheck.c b/fs/ocfs2/blockcheck.c
> index eaf042feaf5e..6e07ddb0e3c0 100644
> --- a/fs/ocfs2/blockcheck.c
> +++ b/fs/ocfs2/blockcheck.c
> @@ -124,7 +124,7 @@ u32 ocfs2_hamming_encode(u32 parity, void *data, unsigned int d, unsigned int nr
>  		 * parity bits that are part of the bit number
>  		 * representation.  Huh?
>  		 *
> -		 * <wikipedia href="https://urldefense.com/v3/__http://en.wikipedia.org/wiki/Hamming_code__;!!GqivPVa7Brio!KcDKP3qB9qOXyB3f-1-Jse08v44QPm7REvV1-Ff83lbAVpV1HBZ8jAtq9cJQwzaxYCLb6g$ ">
> +		 * <wikipedia href="https://urldefense.com/v3/__https://en.wikipedia.org/wiki/Hamming_code__;!!GqivPVa7Brio!KcDKP3qB9qOXyB3f-1-Jse08v44QPm7REvV1-Ff83lbAVpV1HBZ8jAtq9cJQwzY2po7jTQ$ ">
>  		 * In other words, the parity bit at position 2^k
>  		 * checks bits in positions having bit k set in
>  		 * their binary representation.  Conversely, for
> 
