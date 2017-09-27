From: Changwei Ge <ge.changwei@h3c.com>
Date: Wed, 27 Sep 2017 08:46:43 +0000
Subject: [Ocfs2-devel] ocfs2-test supports Python 3
References: <59CBB7F0020000F90008F634@prv-mh.provo.novell.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373CED53713@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 2017/9/27 14:40, Gang He wrote:
> ** PRIVATE **
> 
> Hello guys,
> 
> As you know, some Linux distributions(e.g. SUSE Enterprise Linux 15) will introduce Python3 as the default,
> our Python scripts in ocfs2-test still use Python2, we will have to do proper modifications to migration to Python3 (Larry Chen has worked on this investigation).
> But, the problem is how to maintain the ocfs2-test code between Python2 and Python3? since some existing Linux distributions(include their further SP) use Python2.
> there are two options,
> 1) one code branch, in which the code is compatible with Python2 and Python3, but I feel it is difficult after I talked with Larry Chen.
> 2) two code branches, one branch is for Python2, the other branch is for Python3.
Option 3 is better, I suppose.
> what are your thoughts? please let us know, then we can select a way to work on this task.
>    
> 
> Thanks
> Gang
> 
> 
> 
> 
> 
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
