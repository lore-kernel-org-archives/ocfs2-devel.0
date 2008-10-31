From: tristan.ye <tristan.ye@oracle.com>
Date: Fri, 31 Oct 2008 17:06:04 +0800
Subject: [Ocfs2-devel] [PATCH 00/27] Quotas for OCFS2 (version 3)
In-Reply-To: <12254351572189-git-send-email-jack@suse.cz>
References: y  <12254351572189-git-send-email-jack@suse.cz>
Message-ID: <1225443964.6631.55.camel@tristan-laptop.cn.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On Fri, 2008-10-31 at 07:38 +0100, Jan Kara wrote:
> Hi,
> 
> in this thread comes the third version of the patches implementing quotas for
> OCFS2 (sorry for spamming ocfs2-devel so often with such a big pile of patches
> ;). I've now addressed all Joel's comments (feature bits added among supported
> bits in the last patch, hopefully fixed an oops when enabling quota fails on
> mount), also fixed a bug Tristan reported (message about exceeding softlimit
> was not always properly printed), fixed a bug in node recovery leading to
> possible oops when filesystem was without quotas (reported by Andrew Beekhof)
> and also reported a few style things and compilation problems reported
> by Andrew Morton and other people getting the patches via -mm kernel.  As
> always, comments are welcome (but I won't respond quickly because I'll be
> mostly out of email for next two weeks).
> 								Honza

Thanks for the quick 3rd version of quota patches on ocfs2,is this patch
set based on mark's kernel tree or mainline? i'll soon check my reported
bug on your provided kernel:)

BTW, I've worked out a first version of sanity checker for quota on
ocfs2,now its only on a single-node mode,will try to work on
mutiple-nodes tests later for node crash,heavy parallel quota usage and
negative quota usage test etc.maybe by the help of openmpi tools:)

I've attached the singe-node test script by this mail,you may have it
for sanity check if you wish,it includes one user/one group/multiple
groups test for all quota related generic functions(also soft/hard/grace
time limitaion for inodes and space usage tested here),you also can tune
the workload extremely high to expect it as a stress puncher.

it can be used like,

./quota_tests.sh -o quotalog -d /dev/sdc5 -t ocfs2 -i small /quota (here
-i specify the workload, small means for a generic test,medium and large
increase the stress sharply:)

I've tested you 2rd version of patch set by specifying a medium
workload,the result was good to me:)

The testing status and testing tools will be kept on
http://oss.oracle.com/osswiki/QuotaTest


Regards,

Tristan.

> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
-------------- next part --------------
A non-text attachment was scrubbed...
Name: quota_tests.sh
Type: application/x-shellscript
Size: 25591 bytes
Desc: not available
Url : http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20081031/b74cde20/attachment-0001.bin 
