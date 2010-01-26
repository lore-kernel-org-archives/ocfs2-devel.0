From: Coly Li <coly.li@suse.de>
Date: Wed, 27 Jan 2010 03:52:31 +0800
Subject: [Ocfs2-devel] [PATCH 1/4] du_enhancement: add the shared
 extents and the footprint statistics support v1
In-Reply-To: <1264492809-13848-1-git-send-email-jeff.liu@oracle.com>
References: <> <1264492809-13848-1-git-send-email-jeff.liu@oracle.com>
Message-ID: <4B5F47FF.4080707@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 2010?01?26? 16:00, Jeff Liu Wrote:
> brief introduction:
> 
> the following patch sets add a new feature to displapy the shared extents size per file as well as the
> overall footprint statistics for du command.
> 
> It using rbtree to track the splitted extents info instead of the clusters or physical blocks to save
> the memory in case of the file size is too large(TB, etc).
> 
> the current extent splitting algorithem is based on Tao's idea, thanks a lot!
> 
> use '--shared-size' or '-E' as the command line trigger, with this option,
> du print out the shared extents in parens for each file if its resides filesystem
> support fiemap and the file is reflinked.
> 
> use '--fxattr' or '--fsync' or both of them to work combine with '--shared-size' for the extra fiemap control,
> it will print warning message on the console in case of the filesystem do not support the corresponding fiemap flags.
> 
> Signed-off-by: Jeff Liu <jeff.liu@oracle.com>
> ---

Hi Jeff,

If I understand correctly, this patch series is for coreutils, neither ocfs2 nor ocfs2-tools.
How about Cc bug-coreutils at gnu.org as while ?

-- 
Coly Li
SuSE Labs
