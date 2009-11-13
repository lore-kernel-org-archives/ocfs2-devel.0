From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Fri, 13 Nov 2009 12:32:31 -0800
Subject: [Ocfs2-devel] disable reboots when fencing
In-Reply-To: <DB7C4A32-5E4B-48DA-8456-CDBDD025ACEB@itec.suny.edu>
References: <DB7C4A32-5E4B-48DA-8456-CDBDD025ACEB@itec.suny.edu>
Message-ID: <4AFDC25F.7080909@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

That does not disable reboots. It merely changes the fence method panic.
The default is a pci bus reset.

We don't have it in 1.4 though we could add it back easily. The only use 
I see
is if one needs to get a kernel coredump at the time of the fence.

Hoot, Joseph wrote:
> What is the OCFS2 v1.4 equivalent to the OCFS2 v1.2 command to disable reboots upon fencing?
>
>  echo 1 > /proc/fs/ocfs2_nodemanager/fence_method 
>
> Thanks,
> Joe
>
> ===========================
> Joseph R. Hoot
> Lead System Programmer/Analyst
> (w) 716-878-4832
> (c) 716-759-HOOT
> joe.hoot at itec.suny.edu
> GPG KEY:   7145F633
> ===========================
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>   
