From: tristan <tristan.ye@oracle.com>
Date: Fri, 21 May 2010 17:07:11 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Add new OCFS2_IOC_INFO ioctl
 for ocfs2 v7.
In-Reply-To: <20100520234955.GD8335@mail.oracle.com>
References: <1274236135-5383-1-git-send-email-tristan.ye@oracle.com>
	<20100520232643.GC8335@mail.oracle.com>
	<20100520234955.GD8335@mail.oracle.com>
Message-ID: <4BF64D3F.5030705@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Thu, May 20, 2010 at 04:26:43PM -0700, Joel Becker wrote:
>> On Wed, May 19, 2010 at 10:28:55AM +0800, Tristan Ye wrote:
>>> The reason why we need this ioctl is to offer the none-privileged
>>> end-user a possibility to get filesys info gathering.
>>>
>>> We use OCFS2_IOC_INFO to manipulate the new ioctl, userspace passes a
>>> structure to kernel containing an array of request pointers and request
>>> count, such as,
>> 	This patch fails to build in ia32.  Have you tested it there?
>
> 	I'll be clearer for future reference.  Anyone adding or
> modifying code that handles compat pointers needs to compile and test:
>
> 1) A 32bit user program on a 32bit OS.
> 2) A 32bit user program on a 64bit OS with CONFIG_COMPAT set.
> 3) A 64bit user program on a 64bit OS with CONFIG_COMPAT set.
> 4) A 32bit user program on a 64bit OS with CONFIG_COMPAT *not* set.
> 5) A 64bit user program on a 64bit OS with CONFIG_COMPAT *not* set.
>
> Only test (4) should return an error.
> 	I realize this is a lot of testing, but it only needs to be done
> once.  It's only when you are actually touching CONFIG_COMPAT stuff.

That's definitely a MUST!! since I caught another bug running 32bits 
application on 64bits kernel, the problem is I didn't make the 
'ocfs2_info' structure 64bits aligned, which caused a failure to 
recognize this ioctl from a 32bits application. Following is all that 
I'm going to change against this issue:

--------------------------------------------------------------------------
struct ocfs2_info {
__u64 oi_requests; /* Array of __u64 pointers to requests */
- __u32 oi_count; /* Number of requests in info_requests */
+ __u64 oi_count; /* Number of requests in info_requests */
};

struct ocfs2_info_request {
@@ -102,34 +102,34 @@ struct ocfs2_info_request {

struct ocfs2_info_clustersize {
struct ocfs2_info_request ic_req;
- __u32 ic_clustersize;
+ __u64 ic_clustersize;
};

struct ocfs2_info_blocksize {
struct ocfs2_info_request ib_req;
- __u32 ib_blocksize;
+ __u64 ib_blocksize;
};

struct ocfs2_info_maxslots {
struct ocfs2_info_request im_req;
- __u16 im_max_slots;
+ __u64 im_max_slots;
};

struct ocfs2_info_label {
struct ocfs2_info_request il_req;
__u8 il_label[OCFS2_MAX_VOL_LABEL_LEN];
-};
+} __attribute__ ((packed));

struct ocfs2_info_uuid {
struct ocfs2_info_request iu_req;
__u8 iu_uuid_str[OCFS2_TEXT_UUID_LEN + 1];
-};
+} __attribute__ ((packed));

struct ocfs2_info_fs_features {
struct ocfs2_info_request if_req;
- __u32 if_compat_features;
- __u32 if_incompat_features;
- __u32 if_ro_compat_features;
+ __u64 if_compat_features;
+ __u64 if_incompat_features;
+ __u64 if_ro_compat_features;
};
--------------------------------------------------------------------------


Adding 'packed' attribute also solves the problem as well, that's why I 
made this for ocfs2_info_label and ocfs2_info_uuid to avoid quite a 
redundant expansion.


Eventually my latest patch passes all 1-5 tests(bug out at test 4) as 
expected, and I'll post it soon ;-)



Tristan.

>
> Joel
>
