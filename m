From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 24 Oct 2019 17:06:30 -0700
Subject: [Ocfs2-devel] [PATCH V2 1/2] ocfs2: protect extent tree in the
 ocfs2_prepare_inode_for_write
In-Reply-To: <7db0b888-d885-7e5c-810c-714db6ce63c6@oracle.com>
References: <1568772175-2906-1-git-send-email-sunny.s.zhang@oracle.com>
	<1568772175-2906-2-git-send-email-sunny.s.zhang@oracle.com>
	<CH2PR18MB3206EE61C6BEC30C68EE5AE6CF870@CH2PR18MB3206.namprd18.prod.outlook.com>
	<20873961-3d27-2f0c-47ec-acf275647074@oracle.com>
	<92e25022-9d63-92f5-d3cf-08423c5c97b7@oracle.com>
	<CH2PR18MB320662998E1EC2BA01BA0B88CF6A0@CH2PR18MB3206.namprd18.prod.outlook.com>
	<7db0b888-d885-7e5c-810c-714db6ce63c6@oracle.com>
Message-ID: <20191024170630.684d170b6da79080b28fc1a5@linux-foundation.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, 24 Oct 2019 12:34:11 +0800 sunnyZhang <sunny.s.zhang@oracle.com> wrote:

> @Gang
> 
> Thank you very much!
> 
> I have fixed this issue through upgrading the openmpi.
> 
> I have tested this patch using ocfs2-test. It can work fine.
> 
> @Andrew Please can you help me to summit this patch?

OK, I'll send it in to Linus for 5.4.

Is the problem serious enough to justify also tagging it for
backporting into -stable kernels?
