import Combine
import SwiftUI

struct DocumentChecklistView: View {
    @EnvironmentObject private var store: AppDataStore
    @Environment(\.showSuccessFeedback) private var showSuccessFeedback
    @State private var newDocName = ""
    @State private var showTemplates = false

    private var completedCount: Int {
        store.documents.filter(\.completed).count
    }

    var body: some View {
        ZStack {
            AppBackgroundView()
            Group {
                if store.documents.isEmpty {
                    emptyState
                } else {
                    documentScroll
                }
            }
        }
        .navigationTitle("Travel Documents")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Templates") {
                    FeedbackManager.tapLight()
                    showTemplates = true
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color("AppPrimary"))
            }
        }
        .confirmationDialog("Document Templates", isPresented: $showTemplates, titleVisibility: .visible) {
            ForEach(DocumentTemplates.all) { template in
                Button(template.title) {
                    store.applyDocumentTemplate(template)
                    showSuccessFeedback()
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .safeAreaInset(edge: .bottom) { addBar }
    }

    private var emptyState: some View {
        ScrollView {
            EmptyStateView(
                icon: "doc.text.fill",
                title: "Documents ready?",
                message: "Track passport, visa, tickets, and insurance. Pick a template to start fast.",
                buttonTitle: "Use Template",
                action: { showTemplates = true }
            )
        }
        .clearScrollBackground()
    }

    private var documentScroll: some View {
        ScrollView {
            LazyVStack(spacing: TravelCardStyle.rowSpacing) {
                SectionHeaderView(
                    title: "Checklist",
                    subtitle: "\(completedCount) of \(store.documents.count) complete"
                )
                ForEach(store.documents) { doc in
                    DocumentCell(name: doc.name, completed: doc.completed) {
                        FeedbackManager.tapLight()
                        store.toggleDocument(doc)
                    }
                    .contextMenu {
                        Button("Delete", role: .destructive) {
                            store.deleteDocument(doc)
                        }
                    }
                }
            }
            .padding(.horizontal, TravelCardStyle.horizontalPadding)
            .padding(.vertical, 12)
            .padding(.bottom, 72)
        }
        .clearScrollBackground()
    }

    private var addBar: some View {
        HStack(spacing: 10) {
            TextField("Add document", text: $newDocName)
                .foregroundStyle(Color("AppTextPrimary"))
                .travelInputField()
            Button {
                store.addDocument(newDocName)
                newDocName = ""
                showSuccessFeedback()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundStyle(Color("AppPrimary"))
            }
            .frame(width: 44, height: 44)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color("AppBackground").opacity(0.94))
    }
}
