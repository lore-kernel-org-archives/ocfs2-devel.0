From: Joseph Qi <joseph.qi@huawei.com>
Date: Fri, 27 Mar 2015 10:27:11 +0800
Subject: [Ocfs2-devel] Question about incorrect free bits setting
Message-ID: <5514BFFF.7070009@huawei.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Goldwyn,
I found you posted a mail to discuss about incorrect free bits setting.
https://oss.oracle.com/pipermail/ocfs2-devel/2012-January/008458.html

In this topic, Sunil said it was because of the patch added to delay
dropping of the dentry locks (commit ea455f8ab683) and suggested to fix
the quota issue in a different way.
Then you reverted the patches based on Honza's new way to fix the quota
issue.
https://oss.oracle.com/pipermail/ocfs2-devel/2014-February/009662.html

I have investigated these patches and still do not know how can it
happen.
Could you please tell me more about the case that bits to be cleared
twice?
