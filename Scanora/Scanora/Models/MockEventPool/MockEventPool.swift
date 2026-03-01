//
//  MockEventPool.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import Foundation

/// A pool of event templates for generating arbitrary QR-codes.
enum MockEventPool {
    /// Event template without an identifier.
    struct Template {
        let title: String
        let eventDescription: String
        let date: Date
        let image: String
    }

    /// An array of predefined event templates.
    static let templates: [Template] = {
        let formatter = ISO8601DateFormatter()

        /// Auxiliary function for creating a date from a string.
        func makeDate(_ isoString: String) -> Date {
            formatter.date(from: isoString) ?? Date.now
        }

        return [
            // MARK: - Anthropic Events.

            Template(
                title: "Anthropic and AWS",
                eventDescription: """
                Enterprise intelligence

                Empower your enterprise with advanced AI, seamlessly integrated into your familiar AWS ecosystem. Innovate with confidence, knowing your sensitive data is protected by a robust security framework that ensures compliance across evolving regulatory landscapes.

                Future-proof partnership

                Realize the full potential of AI with a solution that evolves alongside your ambitions. Tailor Claude's capabilities to your unique needs, supported by the partnership of AWS. Our collaborative approach ensures your AI initiatives drive value and innovation, from concept to implementation.
                """,
                date: makeDate("2024-12-11T00:00:00Z"),
                image: "MockAnthropicEventBanner"
            ),

            Template(
                title: "Paris Builder Summit",
                eventDescription: """
                Hear from Anthropic Leadership, engage with top French startups (Dust, Photoroom, HuggingFace), see the latest from Claude, and preview what's next with Anthropic Research Team.

                If you are a founder building at the frontier of AI, join us to learn more about Anthropic's leading family of models, connect with peers, and hear from our research team about what's top of mind and how we can help bring your AI-powered ideas to life.
                """,
                date: makeDate("2025-02-14T00:00:00Z"),
                image: "MockAnthropicEventBanner"
            ),

            Template(
                title: "Seoul Builder Summit",
                eventDescription: """
                Anthropic's first event in Korea, in partnership with Coxwave. Hear from Anthropic Leadership, engage with top Korean startups (Coxwave, WRTN, LinqAlpha, and KLleon), see the latest from Claude, and learn tips and tricks for Claude on production.

                If you are a founder building at the frontier of AI, join us to learn more about Anthropic's leading family of models, connect with peers, and hear from our research team about what's top of mind and how we can help bring your AI-powered ideas to life.
                """,
                date: makeDate("2025-02-24T00:00:00Z"),
                image: "MockAnthropicEventBanner"
            ),

            Template(
                title: "Anthropic and Google Cloud",
                eventDescription: """
                Experience the power of Claude on Google Cloud's Vertex AI at Next 2025

                Every business needs an AI strategy. Anthropic's Claude on Google Cloud's Vertex AI gives you immediate access to advanced AI and agent building capabilities with built-in safeguards and efficient scaling. This isn't just about having powerful technology—it's about putting it to work effectively.
                By bringing together Anthropic's generative AI innovation and Google Cloud's proven infrastructure, you can quickly launch AI projects that deliver real value. With Claude on Vertex AI, you can focus on what matters: solving business problems, improving efficiency, and realizing impact.

                Claude and Vertex AI: Shaping the Future of Business AI Agents

                The combination of Claude on Google Cloud's Vertex AI creates a powerful foundation for developing effective AI agents that can transform your business. Claude's advanced reasoning and ability to handle complex context, coupled with Vertex AI's robust infrastructure and direct integration with Google Cloud services, enables organizations to build AI agents that can plan, act, and adapt autonomously. This combination is crucial for businesses as AI agents become essential for automating complex workflows, enhancing decision-making, and scaling operations.
                """,
                date: makeDate("2025-02-25T00:00:00Z"),
                image: "MockAnthropicEventBanner"
            ),

            Template(
                title: "AWS Summit London",
                eventDescription: """
                With 190+ sessions to choose from, there's something for everyone, including access to training and certifications, chalk talks, workshops, and lightning talks.

                The AWS Summit London is our largest free cloud technology event in the UK. This is where the latest in cloud innovation comes to life, providing an opportunity to explore cutting-edge technologies—from generative AI to serverless computing—that are revolutionising industries and empowering businesses to lead in the digital era.
                """,
                date: makeDate("2025-01-04T00:00:00Z"),
                image: "MockAnthropicEventBanner"
            ),

            Template(
                title: "Code with Claude",
                eventDescription: """
                Code with Claude will offer interactive workshops centered on real-world applications, helping you make the most of frontier AI.

                You'll hear directly from Anthropic's executive and product teams, participate in interactive labs and sessions, meet our technical teams during office hours, and connect with a community of developers building with Claude.

                The conference will showcase how developers are maximizing Claude's capabilities across our models, products, and API. You'll learn about our product roadmap, Claude Code, MCP, development methodologies, AI agent implementation strategies, and tool use patterns from the technical teams building Claude-powered applications at leading companies.
                """,
                date: makeDate("2025-03-04T00:00:00Z"),
                image: "MockAnthropicEventBanner"
            ),

            Template(
                title: "AWS Summit Washington",
                eventDescription: """
                Learn what it takes to drive culture change, digital transformation, and infrastructure modernization. Shape your learning experience through immersive formats that match your goals. Join interactive workshops for hands-on practice, or dive deep into technical sessions led by industry experts.

                Connect with peers in focused discussion forums while exploring solutions in our dynamic Expo. Throughout your journey, you'll build alongside AWS experts who understand your unique challenges.
                """,
                date: makeDate("2025-03-10T00:00:00Z"),
                image: "MockAnthropicEventBanner"
            ),

            Template(
                title: "AWS Summit Tokyo",
                eventDescription: """
                AWS Summit is an event for anyone interested in driving innovation across the cloud, where the cloud computing community gathers to learn about Amazon Web Services (AWS), share best practices, and exchange information.

                Take advantage of the keynote speeches, over 150 sessions, and over 250 EXPO contents to enhance your learning experience.
                """,
                date: makeDate("2025-03-18T00:00:00Z"),
                image: "MockAnthropicEventBanner"
            ),

            Template(
                title: "Claude for Financial Services",
                eventDescription: """
                Financial services faces a distinct challenge: the need for AI that understands both precision and context in a heavily regulated, high-stakes environment. While many AI solutions offer general capabilities, few grasp the nuanced requirements of banking, insurance, and asset management.

                On July 15th, we're bringing together senior executives who are solving this challenge. You'll see how leading institutions are using Claude to drive measurable outcomes across risk analysis, regulatory compliance, customer engagement, and operational efficiency—without sacrificing the judgment and oversight finance demands.

                What you'll experience
                • Hear direct insights from Anthropic leadership on our vision for AI in financial services
                • Understand executive perspectives from your peers at top firms and Anthropic's partners on their AI transformation journeys
                • Witness how Claude's finance-specific capabilities can solve real life problems for financial industry audience

                Who should attend
                Senior leaders shaping AI strategy at financial institutions—from heads of innovation and technology to risk officers and operations executives exploring transformation opportunities.
                """,
                date: makeDate("2025-04-10T00:00:00Z"),
                image: "MockAnthropicEventBanner"
            ),

            Template(
                title: "AWS Summit NYC",
                eventDescription: """
                This complimentary event is your opportunity to learn from industry leaders, collaborate with peers, and get the answers to your questions directly from AWS experts.

                Customize your experience by choosing sessions that best fit your business needs, such as interactive workshops or customer showcases, all while networking with like-minded professionals.
                """,
                date: makeDate("2025-07-14T00:00:00Z"),
                image: "MockAnthropicEventBanner"
            ),

            Template(
                title: "Builder Summit London",
                eventDescription: """
                Join the Anthropic team for our Builder Summit in London, bringing together developers and founders for a technical deep dive. Discover how teams are deploying autonomous AI agents, see exclusive demos of Claude's capabilities, explore the technical foundations of MCP (Model Context Protocol), and learn from the pioneers reshaping industries with AI.

                About Anthropic
                Anthropic is a frontier AI company building reliable, interpretable, and steerable artificial intelligence systems. Founded in 2021 and now one of the most valuable private companies in the world, we are among the fastest growing companies in history. Our flagship AI assistant, Claude, serves millions of users each day, from Fortune 500 companies and government agencies to small businesses and individuals.
                """,
                date: makeDate("2026-04-10T00:00:00Z"),
                image: "MockAnthropicEventBanner"
            ),

            Template(
                title: "The Briefing: Healthcare and Life Sciences",
                eventDescription: """
                Healthcare and life sciences organizations face a distinct challenge: the need for AI that understands both precision and context to accelerate scientific breakthroughs and bring them directly to patients.

                On January 12th, we're bringing together senior executives who are solving this challenge in a free, livestreamed virtual event. Come back to this page at 11:30 AM PST on January 12th to view the livestream.

                What you'll experience
                • Hear direct insights from Anthropic leadership on our vision for AI in healthcare
                • Understand executive perspectives from your peers and Anthropic's partners on their AI transformation journeys
                • Witness how Claude's healthcare-specific capabilities can solve real life problems
                """,
                date: makeDate("2026-04-14T00:00:00Z"),
                image: "MockAnthropicEventBanner"
            ),

            Template(
                title: "The Briefing: Enterprise Agents",
                eventDescription: """
                Out of the box, Claude is a capable generalist. But when you plugin your tools, context, and knowledge, it becomes something more: a specialist who knows your work the way you do.

                On February 24th, we demonstrated how in an exclusive livestream event. Join us from anywhere for product updates that make Cowork even more effective for enterprises, live demos, and a look at what working with Claude will look like in 2026. We're building a future where individuals can have the impact of teams, and we want to get there together.

                What you'll experience
                • New product announcements from Anthropic leadership
                • Live demonstrations of Claude's newest capabilities
                • Technical content on deploying enterprise agents with confidence

                Who should watch
                This event is designed for senior leaders shaping AI strategy at their organizations: CIOs, CROs, General Counsels, and heads of analytics.
                """,
                date: makeDate("2026-08-06T00:00:00Z"),
                image: "MockAnthropicEventBanner"
            ),

            Template(
                title: "Claude on Vertex AI",
                eventDescription: """
                Experience the power of Claude on Google Cloud's Vertex AI

                Most AI agents degrade when task complexity increases or execution runs long. Claude is designed around that constraint.

                Claude on Google Cloud's Vertex AI lets you build production-ready AI agents for long-running, complex tasks. Our advanced reasoning handles complex, multi-step tasks while Vertex AI provides the scalability and integration your team needs.

                Deploy with built-in safeguards, enterprise-grade security, and the infrastructure you already use and trust.

                Build agents for production use cases
                Tasks that run long, branch unexpectedly, or require sustained judgment across multiple systems expose the gap between what models can do in a demo and what they can do in production.

                Organizations like Palo Alto Networks use Claude on Vertex AI to power production systems at scale.

                Our joint customers include enterprises and startups across energy, commerce, software development, and more:
                • Replit: Replit helps anyone build and deploy software in minutes—no coding required—with Claude on Vertex AI
                • Shopify: Shopify powers Sidekick, an AI commerce assistant that helps millions of merchants get expert-level guidance with Claude on Vertex AI
                • Augment Code: Augment Code transforms how developers understand and work with sophisticated codebases with Claude on Vertex AI
                """,
                date: makeDate("2026-09-18T00:00:00Z"),
                image: "MockAnthropicEventBanner"
            ),

            // MARK: - Non-Anthropic Events.

            Template(
                title: "Codex for Software Engineers",
                eventDescription: """
                Join us for a technical overview of Codex, the AI software engineering agent that can help developers write features, debug code, run tests, and navigate large codebases. In this session, we'll demonstrate how engineers are using Codex to accelerate development workflows, automate repetitive tasks, and collaborate more effectively with AI during the software development lifecycle.

                We'll walk through practical examples of how Codex can generate code, answer questions about your repository, and assist with tasks like refactoring, testing, and documentation. Whether you're exploring AI-assisted development for the first time or evaluating how it could fit into your engineering workflow, this session will help you understand the capabilities and practical applications of Codex. Designed for software engineers and technical builders interested in incorporating AI into their development workflows.
                """,
                date: makeDate("2026-09-15T00:00:00Z"),
                image: ""
            ),

            Template(
                title: "Introduction to Codex",
                eventDescription: """
                Join us for a beginner friendly, high-level overview of Codex — the AI system that powers code generation. We'll explain what Codex is, explore examples of how people are using it for real work and everyday tasks, and show how non-technical professionals can benefit from it today. Whether you're curious about the future of AI and software, want to better collaborate with technical teams, or simply want to understand the possibilities, this webinar is your starting point. No coding experience needed!
                """,
                date: makeDate("2025-08-10T00:00:00Z"),
                image: ""
            ),

            Template(
                title: "ChatGPT Foundations: Getting Started with AI",
                eventDescription: """
                Whether you're brand new to AI or looking to sharpen your skills, this introductory session will provide a clear and practical foundation for using ChatGPT effectively. In this hands-on webinar, you'll learn:

                1. What artificial intelligence and large language models (LLMs) are
                2. How ChatGPT works, including key concepts and capabilities
                3. Real-world examples and best practices for prompting
                4. Tips to get reliable, high-quality results faster
                5. Live walkthroughs and demos you can follow along with

                You'll leave with the knowledge and confidence to start using ChatGPT in your daily work, plus resources to continue learning and applying AI responsibly.
                """,
                date: makeDate("2026-10-18T00:00:00Z"),
                image: ""
            ),

            Template(
                title: "ChatGPT for Resumes and Interviews",
                eventDescription: """
                In this webinar, we'll walk through practical ways to use ChatGPT to prepare for new opportunities, from refining your resume to getting ready for interviews. We'll explore how ChatGPT can help you organize your experience, practice interview questions, and build confidence throughout the job search process. This session is designed to be approachable and useful whether you're actively applying for roles or simply looking to strengthen your career readiness. We'll close with time to answer any frequently asked questions we received throughout the session!
                """,
                date: makeDate("2025-03-14T00:00:00Z"),
                image: ""
            )
        ]
    }()

    static var count: Int {
        templates.count
    }
}
