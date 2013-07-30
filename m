From: Jeff Liu <jeff.liu@oracle.com>
Date: Tue, 30 Jul 2013 13:01:30 +0800
Subject: [Ocfs2-devel] [PATCH v2] fs/ocfs2: use list_for_each_entry()
	instead of list_for_each()
In-Reply-To: <51F7E332.5010708@gmail.com>
References: <1374931429-14062-1-git-send-email-yp.fangdong@gmail.com>
	<20130729074928.GB5053@mwanda> <20130729080606.GD5053@mwanda>
	<51F7E332.5010708@gmail.com>
Message-ID: <51F748AA.4060706@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dong Fang <yp.fangdong@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, mfasheh@suse.com, jlbec@evilplan.org, akpm@linux-foundation.org, viro@zeniv.linux.org.uk, sunil.mushran@gmail.com, tim.gardner@canonical.com, xuejiufei@huawei.com, shencanquan@huawei.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

Hi Dong,

On 07/31/2013 12:00 AM, Dong Fang wrote:

> On 07/29/2013 04:06 AM, Dan Carpenter wrote:
>> Oh.  It appears that nothing changed between v1 and v2.  Only the CC
>> list.
>>
>> It's probably that the list moderation on ocfs2-devel was confusing
>> for non-native English speakers the patch submitter thought his
>> patch was dropped.
>>
>> Also mailing lists should have a white list so that I don't get the
>> message every single time.
>>
>> regards,
>> dan carpenter
>>
> sorry about that, i just think i shoud send this patch to linux-fsdevel,
> but ./get_maintainer.pl didn't tell me

It's better to send this patch to ocfs2-devel at oss.oracle.com only, as this
is a specific patch for OCFS2.

Also, we tag OCFS2 kernel patch with "ocfs2" in subject line rather than "fs/ocfs2".

Thanks,
-Jeff
