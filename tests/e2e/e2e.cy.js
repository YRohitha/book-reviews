import { qbitReactTestAlly } from '../support/qbit-helpers';

beforeEach(() => {
  cy.visit('/empty-state');
});

describe('EmptyState e2e tests', () => {
  const config = {
    colourContrastAllThemes: true,
  };
  TestA11y(config);
}
