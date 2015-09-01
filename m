From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Date: Tue, 1 Sep 2015 05:32:16 -0500
Subject: [Ocfs2-devel] ocfs2 version issue
In-Reply-To: <55E50BF8.50004@oracle.com>
References: <55E50BF8.50004@oracle.com>
Message-ID: <55E57EB0.8060207@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Junxiao,

On 08/31/2015 09:22 PM, Junxiao Bi wrote:
> Hi Goldwyn,
>
> Ocfs2 kernel version is removed from commit
> ff8fb335221e2c446b0d4cbea26be371fd2feb64 ("ocfs2: remove versioning
> information"), but Oracle CRS depends on this version, and this made
> Oracle CRS can't be installed. So i think we should revert this commit
> and sync this version with ocfs2-tools. Do you have any other concern
> about this?

We removed the version because it did not make sense. Even if we put in 
the version back we will have to maintain it and will have a similar 
case where the version number in the kernel is way behind the tools 
versions because of lack of updating. Add to it the confusion of users 
who would not know which version to quote.

I suggest the Oracle CRS should be modified to use the kernel version as 
opposed to the ocfs2 kernel module specific versions.


-- 
Goldwyn
