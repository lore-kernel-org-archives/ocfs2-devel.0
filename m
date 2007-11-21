From: Mark Fasheh <mark.fasheh@oracle.com>
Date: Wed Nov 21 07:39:09 2007
Subject: [Ocfs2-devel] [PATCH 1/2] Initalize bitmap_cpg of ocfs2_super
	to be the maximum,take 1
In-Reply-To: <4743F7B6.6040105@oracle.com>
References: <20071116082736.GA3732@tma-pc1.cn.oracle.com>
	<20071116084110.GA3893@tma-pc1.cn.oracle.com>
	<20071120225859.GG28607@ca-server1.us.oracle.com>
	<47436A4A.1030409@oracle.com>
	<20071120232233.GH28607@ca-server1.us.oracle.com>
	<20071120234009.GI28607@ca-server1.us.oracle.com>
	<4743F7B6.6040105@oracle.com>
Message-ID: <20071121153903.GM28607@ca-server1.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Nov 21, 2007 at 05:17:42PM +0800, tao.ma wrote:
> Mark Fasheh wrote:
>> Tao, just let us know if you tested the file system on a very small fs
>> created with the updated mkfs.ocfs2. If you haven't, please do and in any
>> case provide precise details as to how it was tested.
>>
>> Thanks,
>> 	--Mark
>>   
> The patch in ocfs2-test which test a small fs using new mkfs.ocfs2.
> It includes 2 test case:
> 1. create many small files and free them.
> 2. create 2 large files and free them.
> both work ok with the kernel and new mkfs.ocfs2.

Ok, that looks good so:

Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>

At some point, we should add a test in there to ask for an allocation larger
than could actually fit on the volume.
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
