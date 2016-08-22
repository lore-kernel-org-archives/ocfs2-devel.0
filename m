From: Eric Ren <zren@suse.com>
Date: Mon, 22 Aug 2016 16:21:22 +0800
Subject: [Ocfs2-devel] OCFS2 test report for linux vanilla kernel
	V4.8.0-rc2
In-Reply-To: <6705ddee-a26f-6f26-3943-5977f3584502@suse.com>
References: <410483215.37.1471766765455.JavaMail.jenkins@bj-ha-1>
	<6705ddee-a26f-6f26-3943-5977f3584502@suse.com>
Message-ID: <09fc7502-2db4-8a52-c7a2-8fc690f7713e@suse.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Sorry, actually it's already:

4.8.0-rc2-173-g184ca82-1.gacbdb4b-vanilla

Eric

On 08/22/2016 10:42 AM, Eric Ren wrote:
> Hi,
>
>
> The test report below is agaist vanilla kernel v4.7.0. Some highlights:
>
> 1.  As you can see from logs attached, pcmk stack is used with "blocksize=4096, 
> clustersize=32768";
>
> 2. "inline" testcase on multiple nodes failed 3/3 times so far; seems to be a regression 
> issue;
>
> 3. Two cases are skipped:
> o lvb_torture:  libo2dlm [1] doesn't correctly support LVB operations for fs/dlm;
>
>       Actually, ocfs2 tools (mkfs and fsck) even don't need LVB operations, so it is not 
> worth touching
>
>      libo2dlm right now, I think;
>
>     o filecheck: is not scheduled this time;
>
> 4. "discontig test" is missing now:-/
>
>
> If anyone is intersted in  the detailed test logs, I can upload somewhere;-) will schedule 
> test for V4.8.rc2 soon.
>
> [1] https://oss.oracle.com/pipermail/ocfs2-tools-devel/2008-May/000761.html
>
> Eric
>
> run-dev-test
>     *BUILD UNSTABLE*
> Project:     run-dev-test
> Date of build:     Sat, 20 Aug 2016 20:11:19 +0800
> Build duration:     19 hr
> Build cause:     Started by upstream project "zren-testing/ocfs2-dlm-dev" build number 16
> Build description:      linux vanilla kernel V4.7.0
> Built on:     HA-232
>
>
>  Health Report
>
> W     Description     Score
>     Build stability: 2 out of the last 5 builds failed.     60
>     Test Result: 1 test failing out of a total of 29 tests.     96
>
>
>  Tests Reports
>
> <http://147.2.207.237:8080/job/zren-testing/job/run-dev-test/28//testReport>
> Package     Failed     Passed     Skipped     Total
> MultipleNodes     1     8     1     *10*
> MultipleNodes.inline.inline-test
> SingleNode     0     18     1     *19*
>
>
>
