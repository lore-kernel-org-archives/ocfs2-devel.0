From: Changwei Ge <ge.changwei@h3c.com>
Date: Tue, 7 Nov 2017 02:43:20 +0000
Subject: [Ocfs2-devel] ocfs2-test result on
 4.14.0-rc7-1.gdbf3e9b-vanilla kernel
References: <b1b90077-b13f-9d36-4f0e-938f1be7a795@suse.com>
	<0c53b4a2-91ac-44ca-527f-6f5f0b6bd7a4@suse.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373CED75260@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Eric,

On 2017/11/7 10:33, Eric Ren wrote:
> Hi,
> 
> The testing result against the recent kernel looks good. The attachments are
> overall results. If the detailed logs are needed, please let me know.
> 
> Pattern				Failed	Passed	Skipped	Total
> DiscontigBgMultiNode 		0 	4 	0 	4
> DiscontigBgSingleNode 		0 	5 	0 	5
> MultipleNodes 			0 	9 	1 	10
> SingleNode 			0 	18 	1 	19

18 SingleNode cases were failed. Is that normal?

> 
> Notes:
> - This testing only use blocksize=4096 and clustersize=32768 to reduce the time;
> - The 2 skipped cases are on purpose: filecheck and lvb_torture.
> 

I wonder why case - 'lvb_torture' is skipped on purpose?

Thanks,
Changwei

> Cheers,
> Eric
> 
