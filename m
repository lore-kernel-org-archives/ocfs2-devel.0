From: Tristan Ye <tristan.ye@oracle.com>
Date: Fri, 28 Jan 2011 09:46:52 +0800
Subject: [Ocfs2-devel] [PATCH 02/14] Ocfs2/refcounttree: Publicate
 couple of funcs from refcounttree.c
In-Reply-To: <20110128000554.GD23899@wotan.suse.de>
References: <1295605231-15991-1-git-send-email-tristan.ye@oracle.com>
	<1295605231-15991-3-git-send-email-tristan.ye@oracle.com>
	<20110128000554.GD23899@wotan.suse.de>
Message-ID: <4D42200C.3070305@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Mark Fasheh wrote:
> On Fri, Jan 21, 2011 at 06:20:19PM +0800, Tristan Ye wrote:
>   
>> The original goal of commonizing these funcs is to benefit defraging/extent_moving
>> codes in the future,  based on the fact that reflink and defragmentation having
>> the same Copy-On-Wrtie mechanism.
>>
>>     
>
> This looks reasonable. You might want to note the change from struct
> "ocfs2_cow_context *" in some parameters to struct "file *" though.
> 	--Mark
>
> --
> Mark Fasheh
>   

Yea, it will be better to become that descriptive.
