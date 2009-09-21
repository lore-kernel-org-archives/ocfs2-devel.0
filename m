From: Andrew Beekhof <andrew@beekhof.net>
Date: Mon, 21 Sep 2009 11:48:26 +0200
Subject: [Ocfs2-devel] Is Pacemaker integration ready to go?
In-Reply-To: <4E1749DA-A3CE-4E87-B75C-2827576D2DAC@oracle.com>
References: <4A366E4F.6080507@gmail.com>
	<4E1749DA-A3CE-4E87-B75C-2827576D2DAC@oracle.com>
Message-ID: <b80f82d20909210248w584e40d3x364e74f8fb17c1a1@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Sep 18, 2009 at 4:04 AM, Sunil Mushran <sunil.mushran@oracle.com> wrote:
> To use pacemaker today, you will need to install sles11.

Or use the packages from:
   http://download.opensuse.org/repositories/server:/ha-clustering/

I just used them successfully on Fedora 11.

There is also some new documentation for using OCFS2 with Pacemaker at:
   http://www.clusterlabs.org/mediawiki/images/9/9d/Clusters_from_Scratch_-_Apache_on_Fedora11.pdf

> The pacemaker
> bits are being pushed to ocfs2-tools.git. But the git repo is behind
> sles11 atm.

Why is that?
Are you waiting on something from me?

>
> On Jun 15, 2009, at 8:52 AM, Jonathan <jdccdevel@gmail.com> wrote:
>
>> I have seen many references online to being able to use OCFS2 with
>> Pacemaker, but the documentation I have been able to find is very
>> Sparse.
>>
>> I have kernel 2.6.29, and the latest DLM and Pacemaker (using openais)
>> and OCFS2-Tools from GIT. (As of June 13).
>>
>> I was able to build ocfs2_controld.pcmk ... (With some minor changes
>> to
>> the makefile for my install)
>>
>> I noticed the OCF version of o2cb is not in the latest git snapshot of
>> OCFS2-Tools I downloaded. (I found it at
>> http://oss.oracle.com/pipermail/ocfs2-devel/2008-November/003400.html)
>>
>> Is the OCF o2cb not there because Pacemaker integration isn't ready
>> yet?
>>
>> Is there anything else I need or need to know?
>>
>> Thanks
>>
>> Jonathan deBoer
>>
>> --
>>
>> J. deBoer Computer Consulting.
>> 42 Birchmont Dr.
>> Leduc, AB.
>> T9E-8S4
>> cell: 780-717-0669
>>
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
