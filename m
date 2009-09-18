From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 17 Sep 2009 19:04:02 -0700
Subject: [Ocfs2-devel] Is Pacemaker integration ready to go?
In-Reply-To: <4A366E4F.6080507@gmail.com>
References: <4A366E4F.6080507@gmail.com>
Message-ID: <4E1749DA-A3CE-4E87-B75C-2827576D2DAC@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

To use pacemaker today, you will need to install sles11. The pacemaker  
bits are being pushed to ocfs2-tools.git. But the git repo is behind  
sles11 atm.

On Jun 15, 2009, at 8:52 AM, Jonathan <jdccdevel@gmail.com> wrote:

> I have seen many references online to being able to use OCFS2 with
> Pacemaker, but the documentation I have been able to find is very  
> Sparse.
>
> I have kernel 2.6.29, and the latest DLM and Pacemaker (using openais)
> and OCFS2-Tools from GIT. (As of June 13).
>
> I was able to build ocfs2_controld.pcmk ... (With some minor changes  
> to
> the makefile for my install)
>
> I noticed the OCF version of o2cb is not in the latest git snapshot of
> OCFS2-Tools I downloaded. (I found it at
> http://oss.oracle.com/pipermail/ocfs2-devel/2008-November/003400.html)
>
> Is the OCF o2cb not there because Pacemaker integration isn't ready  
> yet?
>
> Is there anything else I need or need to know?
>
> Thanks
>
> Jonathan deBoer
>
> -- 
>
> J. deBoer Computer Consulting.
> 42 Birchmont Dr.
> Leduc, AB.
> T9E-8S4
> cell: 780-717-0669
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
