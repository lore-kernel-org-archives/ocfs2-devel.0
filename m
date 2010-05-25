From: Wengang Wang <wen.gang.wang@oracle.com>
Date: Tue, 25 May 2010 15:35:13 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2/dlm: resend deref to new master
 if recovery occures
In-Reply-To: <201005250732.o4P4lnZf021862@acsinet15.oracle.com>
References: <201005250732.o4P4lnZf021862@acsinet15.oracle.com>
Message-ID: <20100525073513.GC9173@laptop.us.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

please ignore this email, it's sent by a mis-operation.

regards,
wengang.
On 10-05-25 15:31, Wengang Wang wrote:
> When purge a lockres, we unhash the lockres ignore the result of deref request
> and ignore the lockres state.
> There is a problem that rarely happen. It can happen when recovery take places.
> Say node A is the master of the lockres with node B wants to deref and there is
> a node C. If things happen in the following order, the bug is triggered.
