From: Junxiao Bi <junxiao.bi@oracle.com>
Date: Mon, 28 Mar 2016 09:23:55 +0800
Subject: [Ocfs2-devel] [patch 19/25] ocfs2: o2hb: add negotiate timer
In-Reply-To: <56F5F9C9.7040105@huawei.com>
References: <56f2f8b5.J89ZbuqS9aWdapr3%akpm@linux-foundation.org>
	<56F355F7.2040004@oracle.com> <56F5F9C9.7040105@huawei.com>
Message-ID: <56F887AB.8050005@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Yiwen,

On 03/26/2016 10:54 AM, jiangyiwen wrote:
> Hi, Junxiao
> This patch may have a problem. That is journal of every nodes become
> abort when storage down, and then when storage up, because journal
> has become abort, all of operations of metadata will fail. So how to
> restore environment? panic or reset? how to trigger?
Journal aborted means io error was returned by storage, right?
If so, o2hb_thread should also get io error, in this case, nego process
will be bypassed, and nodes will be fenced at last, see "[patch 23/25]
ocfs2: o2hb: don't negotiate if last hb fail".

Thanks,
Junxiao.
> 
> Thanks,
> Yiwen Jiang.
