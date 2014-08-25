From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Mon, 25 Aug 2014 10:13:16 -0700
Subject: [Ocfs2-devel] A deadlock when system do not has sufficient
	memory
In-Reply-To: <53FAD239.7020709@huawei.com>
References: <53F41CAE.2040204@huawei.com> <53F6FFB7.1090305@huawei.com>
	<CAEeiSHVP60=zNcP-Q2bCD_BdD3g8v1a__Vyn4ZMF_8Z97cpE8g@mail.gmail.com>
	<53FA99FD.1090008@huawei.com>
	<CAEeiSHWiPZHKC5gwLTuuZAm3xUeGT48BLNs97qdUgZSMM+AFZQ@mail.gmail.com>
	<53FACC99.8070701@huawei.com>
	<CAEeiSHXurWFQYX5g3oi1U3-Ma4YpKUYF4PaBWyU0oAGxNFTuLg@mail.gmail.com>
	<53FAD239.7020709@huawei.com>
Message-ID: <CAEeiSHXmTbTJsEFbE4C1oZxNFwgR08P+f7KmC3r3usLeUMC1DQ@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Sun, Aug 24, 2014 at 11:05 PM, Joseph Qi <joseph.qi@huawei.com> wrote:

> On 2014/8/25 13:45, Sunil Mushran wrote:
> > Please could you expand on that.
> >
> In our scenario, one node can mount multiple volumes across the
> cluster.
> For instance, N1 has mounted ocfs2 volumes say volume1, volume2,
> volume3. And volume3 may do umount/mount during runtime of other
> volumes.


I meant expand on the deadlock. Say we are mounting a new volume and that
triggers a inode cleanup. That inode being cleaned up will have to be from
one of the mounted volumes. How can this lead to a deadlock?

Two variations:
a) Node death leading to recovery during the mount.
b) Mount atop a mount.

But I cannot still see a deadlock in either scenario.
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20140825/b2f6791f/attachment.html 
