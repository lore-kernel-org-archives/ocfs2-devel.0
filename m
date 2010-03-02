From: tristan <tristan.ye@oracle.com>
Date: Tue, 02 Mar 2010 10:08:04 +0800
Subject: [Ocfs2-devel] [PATCH 1/2] Ocfs2: Move ocfs2 ioctl definitions
 from ocfs2_fs.h to new added ocfs2_ioctl.h.
In-Reply-To: <20100302012121.GC447@mail.oracle.com>
References: <1266997872-17091-1-git-send-email-tiger.yang@oracle.com>
	<20100302012121.GC447@mail.oracle.com>
Message-ID: <4B8C7304.8070108@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Wed, Feb 24, 2010 at 03:51:11PM +0800, Tiger Yang wrote:
>   
>> diff --git a/fs/ocfs2/file.h b/fs/ocfs2/file.h
>> index d66cf4f..eb891db 100644
>> --- a/fs/ocfs2/file.h
>> +++ b/fs/ocfs2/file.h
>> @@ -26,6 +26,8 @@
>>  #ifndef OCFS2_FILE_H
>>  #define OCFS2_FILE_H
>>  
>> +#include "ocfs2_ioctl.h"
>>     
>
> 	I wanted to grab this for the merge window, but I see that
> file.h is still including the new header.  The header should be included
> in the appropriate C file, not here.  Please clean this up.
>   

Currently 'resize.h' and 'file.h' are using ioctl structures from 
'ocfs2_ioctl.h', don't like 'resize.h', which only was included in 
'resize.c', 'file.h' instead was referred everywhere:

fs/ocfs2/quota_global.c:22:#include "file.h"
fs/ocfs2/dir.c:56:#include "file.h"
fs/ocfs2/locks.c:35:#include "file.h"
fs/ocfs2/aops.c:41:#include "file.h"
fs/ocfs2/inode.c:45:#include "file.h"
fs/ocfs2/symlink.c:49:#include "file.h"
fs/ocfs2/mmap.c:42:#include "file.h"
fs/ocfs2/dcache.c:39:#include "file.h"
fs/ocfs2/file.c:51:#include "file.h"
fs/ocfs2/namei.c:55:#include "file.h"
fs/ocfs2/alloc.c:48:#include "file.h"
fs/ocfs2/ioctl.c:18:#include "file.h"
fs/ocfs2/xattr.c:47:#include "file.h"
fs/ocfs2/quota_local.c:17:#include "file.h"
fs/ocfs2/dlmglue.c:47:#include "file.h"
fs/ocfs2/acl.c:32:#include "file.h"

We therefore need to add 'ocfs2_ioctl.h' in many C sources to avoid 
compile warnings.

Does it worth doing this? or maybe we can just add the 'ocfs2_ioctl.h' 
into 'ocfs2.h', the downside is, it may cause some innocent sources 
start including this undesired header.


Regards,
Tristan
>   


> Joel
>
>   
